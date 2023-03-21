//
//  WeatherInfoResponse.swift
//  WeatherApp

import Foundation

struct WeatherInfoResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let visibility: Double
    let name: String
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let pressure: Double
    let humidity: Double
}

struct Wind: Decodable {
    let speed: Double
}
