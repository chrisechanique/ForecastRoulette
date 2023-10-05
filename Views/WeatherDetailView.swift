//
//  WeatherDetailView.swift
//  CliMate
//
//  Created by Chris Echanique on 28/9/23.
//

import SwiftUI
import Combine
import CoreLocation

struct WeatherDetailView: View {
    @ObservedObject var viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack { // Use HStack to extend horizontally
            VStack(spacing: 0.0) {
                VStack(spacing: 5.0) {
                    Text(viewModel.locationName)
                        .font(.title)
                        .foregroundColor(Color.secondaryTextColor)
                        .lineLimit(1)
                        .accessibilityIdentifier("locationNameLabel")
                    Text(viewModel.temperature)
                        .font(.custom("", size: 60))
                        .foregroundColor(Color.primaryTextColor)
                        .accessibilityIdentifier("temperatureLabel")
                }
                VStack {
                    HStack(alignment: .center, spacing: 5.0) {
                        AsyncImage(url: viewModel.iconURL, scale: 2)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.clear)
                            .accessibilityIdentifier("weatherImageView")
                        Text(viewModel.highLowTemperature)
                            .font(.title3)
                            .foregroundColor(Color.primaryTextColor)
                            .accessibilityIdentifier("highLowTemperatureLabel")
                    }
                    Text(viewModel.weatherDescription)
                        .font(.body)
                        .foregroundColor(Color.primaryTextColor)
                        .fontWeight(/*@START_MENU_TOKEN@*/.thin/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("weatherDescriptionLabel")
                }
            }
            .foregroundColor(.black)
            .padding(20)
        }
        // Expand VStack to the edges of the screen
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.opacity(0.7))
        .cornerRadius(20)
    }
}

#Preview {
    WeatherDetailView(viewModel: WeatherViewModel.init(location: CLLocation.barcelonaLocation, locationName: "Barcelona", weatherDescription: "Tap button to refresh"))
}
