//
//  WeatherDetailViewModel.swift
//  ForecastRoulette
//
//  Created by Chris Echanique on 28/9/23.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit

struct WeatherMapMarker: Identifiable {
    var coordinate: CLLocationCoordinate2D
    public var id: String {
        return "\(coordinate.latitude)_\(coordinate.longitude)"
    }
}

class WeatherViewModel: ObservableObject {
    class Constants {
        static let defaultErrorMessage = "Failed to load data. Please check connection and try again."
    }
    
    @Published var locationName: String
    @Published var temperature: String
    @Published var iconURL: URL? = WeatherData.defaultIconUrL
    @Published var highLowTemperature: String
    @Published var weatherDescription: String
    @Published var location:CLLocation {
        didSet {
            guard oldValue != location else { return }
            mapMarkers.append(WeatherMapMarker(coordinate: location.coordinate))
        }
    }
    @Published var useFahrenheit = false {
        didSet {
            guard useFahrenheit != oldValue else { return }
            fetchWeather(for: location)
        }
    }
    @Published var mapMarkers: [WeatherMapMarker]
    
    private var unitText: String { useFahrenheit ? "°F" : "°C" }
    
    // Default initializer with default values
    init(location:CLLocation,
         locationName: String,
         temperature: String = "-°C",
         iconURL: URL? = WeatherData.defaultIconUrL,
         highLowTemperature: String = "-/- °C",
         weatherDescription: String) {
        self.locationName = locationName
        self.temperature = temperature
        self.iconURL = iconURL
        self.highLowTemperature = highLowTemperature
        self.weatherDescription = weatherDescription
        self.location = location
        self.mapMarkers = [WeatherMapMarker(coordinate: location.coordinate)]
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func generateNewRandomLocation() {
        let randomLocation = CLLocation.randomLocation()
        fetchWeather(for: randomLocation)
    }
    

    func fetchWeather(for location: CLLocation) {
        WeatherServiceManager.shared.fetchWeatherData(for: location, units: useFahrenheit ? .imperial : .metric)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.updateToEmptyState(with: Constants.defaultErrorMessage)
                }
            }, receiveValue: { [weak self] weatherData in
                guard let self = self else { return }
                guard !weatherData.name.isEmpty else {
                    // Handles cases where location name is unresolved (ie location is in the ocean)
                    // Here we reverse geocode the location and use the resolved CLPlacemark to update the view model
                    location.reverseGeocode()
                        .sink(receiveCompletion: { [weak self] completion in
                            guard let self = self else { return }
                            switch completion {
                            case .finished:
                                break
                            case .failure:
                                self.updateToEmptyState(with: Constants.defaultErrorMessage)
                            }
                        }, receiveValue: { [weak self] placemark in
                            guard let self = self else { return }
                            self.update(with: location, weatherData: weatherData, placemark: placemark)
                        })
                        .store(in: &cancellables)
                    return
                }
                
                // Update view model properties with weather data
                self.update(with: location, weatherData:weatherData)
            })
            .store(in: &cancellables)
    }
    
    private func update(with location: CLLocation, weatherData: WeatherData, placemark: CLPlacemark? = nil) {
        withAnimation {
            self.location = location
            // Update view model properties with weather data
            iconURL = weatherData.weatherIconURL
            temperature = "\(Int(weatherData.main.temp))\(unitText)" // Format temperature as needed
            locationName = locationName(with: weatherData, placemark: placemark)
            let feelsLikeText = "Feels like \(weatherData.main.feels_like)\(unitText)"
            let description = weatherData.weather.first?.description ?? ""
            weatherDescription = "\(feelsLikeText). \(description.capitalizedSentence)."
            highLowTemperature = "\(Int(weatherData.main.temp_max)) / \(Int(weatherData.main.temp_min))\(unitText)"
        }
    }
    
    private func locationName(with weatherData: WeatherData, placemark: CLPlacemark? = nil) -> String {
        let placemarkLocationName = placemark?.locality ?? placemark?.name ?? ""
        // Default to the name provided by the weather api, otherwise use placemark name (ie for locations in oceans)
        let locationName = !weatherData.name.isEmpty ? weatherData.name : placemarkLocationName
        
        // The api is providing numbers for some cases instead of text. Let's provide a default value
        if locationName.isEmpty || locationName.containsNumbers {
            return "Unknown"
        }
        return locationName
    }
    
    private func updateToEmptyState(with description: String) {
        iconURL = WeatherData.defaultIconUrL
        temperature = "-\(unitText)" // Format temperature as needed
        locationName = ""
        weatherDescription = description
        highLowTemperature = "-/- \(unitText)"
    }
}

private extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
    var containsNumbers: Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        return rangeOfCharacter(from: decimalCharacters) != nil
    }
}

extension WeatherViewModel {
    static func defaultBarcelonaModel() -> WeatherViewModel {
        return WeatherViewModel(location: CLLocation.barcelonaLocation, locationName: "", temperature: "-°C", iconURL: WeatherData.defaultIconUrL, highLowTemperature: "-/- °C", weatherDescription: "Tap button to refresh.")
    }
}

extension CLLocation {
    static let barcelonaLocation = CLLocation(latitude: 41.3874, longitude: 2.1686)
}
