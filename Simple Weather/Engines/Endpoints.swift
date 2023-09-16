//
//  Endpoints.swift
//  Simple Weather
//
//  Created by Nicholas Kraft on 9/15/23.
//

import Foundation

// Struct to provide a namespace
struct Endpoints {
    // Most programs I've worked on use a manifest file downloaded from the home server to keep track of endpoints.
    // I don't have the infrastructure to set that up but for maintainability it's nice to have these all in one place.
    
    static let directGeocoder = "https://api.openweathermap.org/geo/1.0/direct"
    static let reverseGeocoder = "https://api.openweathermap.org/geo/1.0/reverse"
    static let currentWeather = "https://api.openweathermap.org/data/2.5/weather"
}
