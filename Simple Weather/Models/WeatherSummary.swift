//
//  WeatherSummary.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class WeatherSummary: Codable, Identifiable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
