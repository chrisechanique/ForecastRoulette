//
//  CLLocation+RandomLocation.swift
//  ForecastRoulette
//
//  Created by Chris Echanique on 28/9/23.
//

import CoreLocation
import Combine

extension CLLocation {
    enum RandomLocationError: Error {
        case maxAttemptsReached
    }
    
    // Declare cancellables here
    private static var cancellables: Set<AnyCancellable> = []
    
    static func randomLocation() -> CLLocation {
        let randomLatitude = Double.random(in: -90.0...90.0)
        let randomLongitude = Double.random(in: -180.0...180.0)
        
        return CLLocation(latitude: randomLatitude, longitude: randomLongitude)
    }
    
    func reverseGeocode() -> AnyPublisher<CLPlacemark, Error> {
        return Future<CLPlacemark, Error> { promise in
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(self) { placemarks, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                if let firstPlacemark = placemarks?.first {
                    promise(.success(firstPlacemark))
                } else {
                    promise(.failure(NSError(domain: "NoPlacemarkError", code: 0, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
