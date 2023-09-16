//
//  ViewController.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var readouts: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureReadoutLabel: UILabel!
    @IBOutlet weak var minTemperatureReadoutLabel: UILabel!
    @IBOutlet weak var maxTemperatureReadoutLabel: UILabel!
    @IBOutlet weak var humidityReadoutLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var unitsControl: UISegmentedControl!
    
    private var session: Session?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readouts.isHidden = true
        
        session = Session.init()
        session?.state = Session.PersistedState.init()
        session?.locationManager?.delegate = self
        
        if let units = session?.state.units {
            switch units {
            case CurrentWeatherQuery.Units.imperial.rawValue:
                unitsControl.selectedSegmentIndex = 0
            case CurrentWeatherQuery.Units.metric.rawValue:
                unitsControl.selectedSegmentIndex = 1
            default:
                unitsControl.selectedSegmentIndex = 0
                session?.state.units = CurrentWeatherQuery.Units.imperial.rawValue
            }
        }
        
        if let cityName = session?.state.cityName {
            locationLabel.text = cityName
        }

        if let state = session?.state, state.cityLat != nil && state.cityLon != nil && state.cityName != nil {
            queryForcast()
        }
    }

    func showActivity() {
        // block UI and show and activity indicator
    }
    
    func hideActivity() {
        // Unblock the UI and hide the activity indicator
    }
    
    func queryCity(_ name: String) {
        showActivity()
        GeocoderQuery.directUS(name) { [weak self] (response, error) in
            guard let self else { return }
            self.hideActivity()
            if let error {
                self.showAlertForError(error)
                return
            }
            if let response {
                self.locationLabel.text = response.name
                self.session?.state.cityName = response.name
                self.session?.state.cityLat = response.lat
                self.session?.state.cityLon = response.lon
                self.queryForcast()
            }
        }
    }
    
    func queryCoordinates(_ coordinates: CLLocationCoordinate2D) {
        // should compare to cached and exit early
        showActivity()
        GeocoderQuery.reverse(coordinates) { [weak self] (response, error) in
            guard let self else { return }
            if let error {
                self.showAlertForError(error)
                return
            }
            if let response {
                let locationString = response.local_names[Locale.current.language.minimalIdentifier] ?? response.name
                self.locationLabel.text = locationString
                self.session?.state.cityName = locationString
                self.session?.state.cityLat = response.lat
                self.session?.state.cityLon = response.lon
                self.queryForcast()
            }
        }
    }
    
    func queryForcast() {
        guard let lat = session?.state.cityLat, let lon = session?.state.cityLon else {
            let alertController = UIAlertController.init(title: NSLocalizedString("Alert", comment: "Generic title for alerts"), message: "Unable to retrieve location data", preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: NSLocalizedString("Ok", comment: "Generic text for non-destructive choice in an alert box"), style: .default))
            present(alertController, animated: true)
            return
        }
        
        let location = CLLocation.init(latitude: lat, longitude: lon)
        let units = CurrentWeatherQuery.unitEnumForString(session?.state.units)
        showActivity()
        CurrentWeatherQuery.currentWeather(location: location, units: units) { [weak self] (response, error) in
            guard let self else { return }
            self.hideActivity()
            if let error {
                self.showAlertForError(error)
                return
            }
            if let response {
                self.locationLabel.text = response.name
                self.temperatureReadoutLabel.text = "\(response.main?.temp ?? 0)"
                self.minTemperatureReadoutLabel.text = "\(response.main?.temp_min ?? 0)"
                self.maxTemperatureReadoutLabel.text = "\(response.main?.temp_max ?? 0)"
                self.humidityReadoutLabel.text = "\(response.main?.humidity ?? 0)"
                self.weatherImage.image = UIImage.init(named: response.weather?.first?.icon ?? "")
                self.readouts.isHidden = false
            }
        }
    }
    
    func showAlertForError(_ error: Error) {
        let alertController = UIAlertController.init(title: NSLocalizedString("Alert", comment: "Generic title for alerts"), message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: NSLocalizedString("Ok", comment: "Generic text for non-destructive choice in an alert box"), style: .default))
        present(alertController, animated: true)
    }
    
    @IBAction func unitsSelectionChanged(_ sender: Any) {
        assert(sender as? UISegmentedControl === unitsControl, "Unknown Sender")
        if let segmentControl = sender as? UISegmentedControl {
            switch segmentControl.selectedSegmentIndex {
            case 0:
                session?.state.units = CurrentWeatherQuery.Units.imperial.rawValue
            case 1:
                session?.state.units = CurrentWeatherQuery.Units.metric.rawValue
            default:
                break
            }
            queryForcast()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = self.searchBar.searchTextField.text {
            self.queryCity(searchText)
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startMonitoringVisits()
            if let coordinates = manager.location?.coordinate {
                queryCoordinates(coordinates)
            }
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        queryCoordinates(visit.coordinate)
    }
}

