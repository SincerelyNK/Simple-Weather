//
//  WeatherRain.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class WeatherPrecipitation: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }

    var oneHour: Float = 0
    var threeHour: Float = 0
}
