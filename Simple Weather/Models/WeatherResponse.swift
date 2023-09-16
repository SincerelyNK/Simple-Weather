//
//  WeatherResponse.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

class WeatherResponse : Codable, Identifiable {
    var coord: WeatherCoordinates?
    var weather: [WeatherSummary]?
    var base: String
    var main: WeatherMain?
    var visibility: Float
    var wind: WeatherWind?
    var clouds: WeatherClouds?
    var dt: Int64
    var sys: WeatherSys?
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int
    var rain: WeatherPrecipitation?
    var snow: WeatherPrecipitation?
}
