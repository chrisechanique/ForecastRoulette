//
//  Color+Semantic.swift
//  CliMate
//
//  Created by Chris Echanique on 29/9/23.
//

import SwiftUI

extension Color {
    static var primaryTextColor: Color {
        return Color(.label)
    }
    
    static var secondaryTextColor: Color {
        return Color.weatherOrange
    }
    
    static var backgroundColor: Color {
        return Color(.systemBackground)
    }
    
    static var buttonTint: Color {
        return Color.weatherOrange
    }
    
    private static let weatherOrange = {
        return Color(red: 240.0 / 255.0, green: 107.0 / 255.0, blue: 66.0 / 255.0)
    }()
}
