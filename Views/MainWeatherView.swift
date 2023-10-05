//
//  ContentView.swift
//  CliMate
//
//  Created by Chris Echanique on 28/9/23.
//

import SwiftUI
import MapKit

import Foundation
import Combine
import CoreLocation

// Shake animation for WeatherDetailView
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:0,
                    y: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))))
    }
}

struct WeatherUnitToggle: View {
    private let unitText = "°C / °F"
    @Binding var useFahrenheit: Bool
    var body: some View {
        HStack {
            VStack(spacing: 5.0) {
                Text("°C / °F")
                    .font(.footnote)
                    .accessibilityIdentifier("temperatureToggleText")
                Toggle(unitText, isOn: $useFahrenheit)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color.buttonTint))
                    .accessibilityIdentifier("temperatureToggle")
            }
        }
    }
}


struct MainWeatherView: View {
    @StateObject private var viewModel = WeatherViewModel.defaultBarcelonaModel()
    
    @State private var refreshCount: Double = 0
    
    var body: some View {
        ZStack {
            // Map View (Fill the whole screen)
            WeatherMapView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
                .accessibilityIdentifier("mapView")

            // Weather Detail View (Top-centered)
            VStack {
                WeatherDetailView(viewModel: viewModel)
                    .padding([.leading, .trailing])
                    .shadow(color: Color.gray, radius: 10, x: 0, y: 5)
                    .modifier(ShakeEffect(animatableData: CGFloat(refreshCount)))
                    .accessibilityIdentifier("weatherDetail")
                    
                Spacer()
            }

            // Refresh Button (Bottom Right Corner)
            VStack {
                Spacer()
                HStack {
                    WeatherUnitToggle(useFahrenheit: $viewModel.useFahrenheit)
                        .padding(16)
                        .accessibilityIdentifier("weatherUnitToggle")
                    Spacer()
                    // Location refresh button
                    Button(action: {
                        withAnimation {
                            refreshCount += 1
                        }
                        // Handle refresh action here
                        viewModel.generateNewRandomLocation()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(20)
                            .background(Color.buttonTint)
                            .clipShape(Circle())
                            .rotationEffect(.degrees(refreshCount * 360))
                            .shadow(color: Color.gray, radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(16)
                    .accessibilityIdentifier("refreshButton")
                }
            }
        }
        .onAppear {
            viewModel.fetchWeather(for: viewModel.location)
        }
    }
}

#Preview {
    MainWeatherView()
}
