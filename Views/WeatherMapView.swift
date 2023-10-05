//
//  WeatherMapView.swift
//  CliMate
//
//  Created by Chris Echanique on 28/9/23.
//

import SwiftUI
import MapKit

struct WeatherMapView: View {
    @ObservedObject var viewModel: WeatherViewModel
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: viewModel.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))), interactionModes: .all, showsUserLocation: false, annotationItems: viewModel.mapMarkers) { marker in
            MapMarker(coordinate: marker.coordinate, tint: Color.buttonTint)
        }
    }
}

