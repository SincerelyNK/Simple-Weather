//
//  DirectGeocoderResponse.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class DirectGeocoderResponseArray: Codable, Identifiable {
    var records: [DirectGeocoderResponse]
}

class DirectGeocoderResponse: Codable, Identifiable {
    var name: String
    var lat: Double
    var lon: Double
    var country: String
    var state: String?
    var local_names: [String : String]
}
