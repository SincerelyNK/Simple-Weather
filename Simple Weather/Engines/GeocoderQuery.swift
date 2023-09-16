//
//  GeocoderQuery.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation
import CoreLocation

struct GeocoderQuery {
    
    // Scope of the app is US only
    
    static func directUS(_ city: String, completion: @escaping((DirectGeocoderResponse?, Error?)->Void)) {
        let parameters = ["q" : "\(city),US", "appid" : weatherAPIKey, "lang" : Locale.current.language.minimalIdentifier, "limit" : "1"]
        guard let request = HTTPRequestHandler.weatherRequestBuilder(base: Endpoints.directGeocoder, parameters: parameters) else {
            // Move out of the current call stack even when returning early
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }

        // Look into async/await to get rid of some of this boiler plate
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
                let decodedData = try decoder.decode([DirectGeocoderResponse].self, from: data)
                DispatchQueue.main.async {
                    // Might want to explore returning the entire array and letting the user disabiguate which location they meant.
                    completion(decodedData.first, response.error)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    static func reverse(_ location: CLLocationCoordinate2D, completion: @escaping((ReverseGeocoderResponse?, Error?)->Void)) {
        let parameters = ["lat" : "\(location.latitude)", "lon" : "\(location.longitude)"]
        guard let request = HTTPRequestHandler.weatherRequestBuilder(base: Endpoints.reverseGeocoder, parameters: parameters) else {
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
                let decodedData = try decoder.decode([ReverseGeocoderResponse].self, from: data)
                DispatchQueue.main.async {
                    // Might want to explore returning the entire array and letting the user disabiguate which location they meant.
                    completion(decodedData.first, response.error)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
