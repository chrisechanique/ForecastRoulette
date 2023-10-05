//
//  WeatherServiceManager.swift
//  ForecastRoulette
//
//  Created by Chris Echanique on 28/9/23.
//

import Foundation
import Combine
import CoreLocation

enum WeatherUnits: String {
    case standard
    case metric
    case imperial
}

class WeatherServiceManager {
    static let shared = WeatherServiceManager()
    private let apiKey = "ae103060692fe13422deb98285505dc6"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeatherData(for location: CLLocation, units: WeatherUnits) -> AnyPublisher<WeatherData, Error> {
        // Construct the URL with the "units" parameter
        let urlString = "\(baseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=\(units.rawValue)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: WeatherData.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .catch { (error: Error) -> AnyPublisher<WeatherData, Error> in
                    return Fail(error: error).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
    }
}
