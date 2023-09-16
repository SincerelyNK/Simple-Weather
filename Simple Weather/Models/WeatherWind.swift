//
//  WeatherWind.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class WeatherWind: Codable, Identifiable {
    var speed: Float
    var deg: Float
    var gust: Float?
}
