//
//  WeatherData.swift
//  ForecastRoulette
//
//  Created by Chris Echanique on 28/9/23.
//

import Foundation

struct WeatherData: Codable {
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct WeatherDescription: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int?
        let grnd_level: Int?
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    struct Rain: Codable {
        let oneHour: Double?
        
        // Define CodingKeys for custom JSON key mapping
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    let coord: Coord
    let weather: [WeatherDescription]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: TimeInterval
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

extension WeatherData {
    var weatherIconURL: URL? {
        guard let iconName = weather.first?.icon else {
            return nil
        }
        return WeatherData.url(for: iconName)
    }
    
    static let defaultIconUrL: URL? = {
        return url(for: "03d") // Cloud image
    }()
    
    static private func url(for iconName: String) -> URL? {
        let urlString = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        return URL(string: urlString)
    }
}
