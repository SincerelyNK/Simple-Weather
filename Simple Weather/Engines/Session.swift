//
//  Session.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import UIKit
import CoreLocation

class Session {
    static let UserDefaultsPersistKey = "WeatherUIState"
    struct PersistedState: Codable {
        var cityName: String?
        var cityLat: Double?
        var cityLon: Double?
        var units: String?
    }
    
    var state: PersistedState
    var locationManager: CLLocationManager?
    
    init() {
        if let oldState = Session.readState() {
            state = oldState
        } else {
            state = PersistedState.init()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.main) { [weak self] (_) in
            guard let self else {
                return
            }
            _ = self.writeState()
        }
        
        locationManager = CLLocationManager()
    }
    
    
    private static func readState() -> PersistedState? {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsPersistKey) {
            do {
                let session = try JSONDecoder().decode(PersistedState.self, from: data)
                return session
            } catch let error {
                print(error)
            }
        }
        return nil
    }
    
    private func writeState() -> Bool {
        do {
            let data = try JSONEncoder().encode(state)
            UserDefaults.standard.set(data, forKey: Session.UserDefaultsPersistKey)
            return true
        } catch let error {
            print(error)
        }
        return false
    }
}
