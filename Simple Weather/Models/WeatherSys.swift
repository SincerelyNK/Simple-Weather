//
//  WeatherSys.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class WeatherSys: Codable, Identifiable {
    var type: Int
    var id: Int
    var country: String
    var sunrise: Int64
    var sunset: Int64
}
