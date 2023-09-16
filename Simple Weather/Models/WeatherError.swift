//
//  WeatherError.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class WeatherError: Codable, Identifiable {
    var cod: Int
    var message: String
    var parameters: [String]?
}
