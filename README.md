# ForecastRoulette - Weather App

## Overview

ForecastRoulette is a weather application that provides users with the current weather information for a random location. This app is built using SwiftUI and utilizes the OpenWeatherMap API to retrieve weather data.

## Architecture

The architecture of ForecastRoulette follows a Model-View-ViewModel (MVVM) design pattern, which separates the user interface (View) from the underlying data and business logic (ViewModel). Here's a brief overview of each component:

- **Model**: The data model represents the structure of weather data retrieved from the OpenWeatherMap API. It includes properties like location name, temperature, and icon URL.

- **ViewModel**: The ViewModel is responsible for managing the presentation logic and data binding between the Model and the View. It contains the business logic for fetching weather data, error handling, and data formatting. The ViewModel communicates with the View through `@Published` properties.

- **View**: The View layer is built using SwiftUI and represents the user interface. It displays weather information, handles user interactions, and updates the UI based on changes in the ViewModel's data.

## User Functionality

ForecastRoulette offers the following user functionality:

1. **Random Weather**: Upon launching the app, users can tap a "Get Random Weather" button to fetch weather data for a random location.

2. **Display Weather**: The app displays the following weather information for the random location:
   - Location name
   - Current temperature
   - Weather icon
   - Description
   - Map location

3. **Toggle Temperature Units**: Users can toggle between Fahrenheit (°F) and Celsius (°C) to switch the temperature units.

4. **Light/Dark Mode**: The app supports both light and dark mode for user interface customization.

5. **Map View**: The locations queried are displayed on a map view with markers, allowing users to pan the map to see all locations.

6. **Default/Error States**: The app defaults to Barcelona on app launch and also displays an error message to user upon request failures.

6. **Animations and Haptic Feedback**: When the "Refresh" button is tapped, the app provides animations and haptic feedback to enhance the user experience.

## Limitations

ForecastRoulette has a few limitations:

1. **Single Location**: The app fetches weather data for a random location but does not allow users to specify a specific location.

2. **Limited Weather Information**: The app provides basic weather information (location name, temperature, and icon) but does not include extended forecasts or additional details.

3. **Offline Use**: The app requires an internet connection to fetch weather data from the OpenWeatherMap API. It does not support offline use or caching of data.

4. **Some Random Locations in Water**: Some random locations may happen in bodies of water, which don't have a name provided by the weather API. Instead, the app reverse geocodes the location using CoreLocation to provide this info.

## Getting Started

To run the app locally, follow these steps:

1. Clone the repository to your local machine.

2. Open the Xcode project.

3. Build and run the app on a simulator or device.

4. Tap the "Get Random Weather" button to fetch weather data.

5. Pan the map to see all markers for all queried locations.

6. Use the toggle to switch between Celsius (°C) and Fahrenheit (°F) temperature units.

## Credits

ForecastRoulette uses weather data provided by the OpenWeatherMap API (https://openweathermap.org/).
