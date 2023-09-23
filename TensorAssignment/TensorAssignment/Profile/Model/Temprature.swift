//
//  Temprature.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import Foundation

import Foundation

// MARK: - Temperatures
struct Temperatures: Codable {
    var lat, lon: Double?
    var timezone: String?
    var timezoneOffset: Int?
    var current: Current?
    var daily: [Daily]?

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, daily
    }
}

// MARK: - Current
struct Current: Codable {
    var dt, sunrise, sunset: Int?
    var uvi,temp, feelsLike: Double?
    var pressure, humidity: Int?
    var dewPoint: Double?
    var clouds, visibility: Int?
    var windSpeed: Double?
    var windDeg: Int?
    var windGust: Double?
    var weather: [Weather]?
    var rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, rain
    }
}

// MARK: - Rain
struct Rain: Codable {
    var the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Weather
struct Weather: Codable {
    var id: Int?
    var main, description, icon: String?
}

// MARK: - Daily
struct Daily: Codable {
    var dt, sunrise, sunset, moonrise: Int?
    var moonset: Int?
    var moonPhase: Double?
    var temp: Temp?
    var feelsLike: FeelsLike?
    var pressure, humidity: Int?
    var dewPoint, windSpeed: Double?
    var windDeg: Int?
    var windGust: Double?
    var weather: [Weather]?
    var clouds: Int?
    var pop, rain, uvi: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    var day, night, eve, morn: Double?
}

// MARK: - Temp
struct Temp: Codable {
    var day, min, max, night: Double?
    var eve, morn: Double?
}
