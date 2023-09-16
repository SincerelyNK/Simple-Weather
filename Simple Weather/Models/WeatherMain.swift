//
//  WeatherMain.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class WeatherMain : Codable, Identifiable {
    var temp: Float
    var feels_like: Float
    var temp_min: Float
    var temp_max: Float
    var humidity: Float
    var pressure: Float
    var sea_level: Float?
    var grnd_level: Float?
}
