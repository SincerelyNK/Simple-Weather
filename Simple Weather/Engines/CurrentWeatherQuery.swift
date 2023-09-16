//
//  WeatherQuery.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation
import CoreLocation

struct CurrentWeatherQuery {
    enum Units: String {
        case standard = "standard"
        case metric = "metric"
        case imperial = "imperial"
    }
    
    static func unitEnumForString(_ plainString: String?) -> Units {
        switch (plainString) {
        case Units.metric.rawValue:
            return Units.metric
        case Units.imperial.rawValue:
            return Units.imperial
        default:
            return Units.imperial
        }
        
    }
    
    static func currentWeather(location: CLLocation, units: Units, completion: @escaping((WeatherResponse?, Error?)->Void)) {
        let parameters = ["lat" : "\(location.coordinate.latitude)", "lon" : "\(location.coordinate.longitude)", "units" : units.rawValue, "lang" : Locale.current.language.minimalIdentifier]
        guard let request = HTTPRequestHandler.weatherRequestBuilder(base: Endpoints.currentWeather, parameters: parameters) else {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        HTTPRequestHandler.performRequest(request) { [completion] response in
            guard let data = response.data else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
            guard response.error == nil else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData: WeatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData, response.error)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
