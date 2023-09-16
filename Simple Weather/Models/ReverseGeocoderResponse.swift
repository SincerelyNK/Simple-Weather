//
//  ReverseGeocoderResponse.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class ReverseGeocoderResponse: Codable, Identifiable {
    var name: String
    var local_names: [String : String]
    var lat: Double
    var lon: Double
    var country: String
    var state: String?
}
