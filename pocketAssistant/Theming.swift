//
//  Theming.swift
//  pocketAssistant
//
//  Created by William on 29/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import MaterialComponents
func globalColorScheme() -> MDCSemanticColorScheme {
    let colorScheme = MDCSemanticColorScheme()
    colorScheme.primaryColor = UIColor(red: 170, green: 170, blue: 170)
    return colorScheme
}

func textFieldColorScheme() -> MDCSemanticColorScheme {
    let colorScheme = MDCSemanticColorScheme()
    colorScheme.primaryColor = .black
    colorScheme.onSurfaceColor = .gray
    return colorScheme
}

func globalContainerScheme() -> MDCContainerScheming {
    let containerScheme = MDCContainerScheme()
    // Customize containerScheme here...
    containerScheme.colorScheme.primaryColor = .black
//    containerScheme.colorScheme.onPrimaryColor = .yellow

//
    
    return containerScheme
}

// You can now access your global theme throughout your app:
//    let containerScheme = globalContainerScheme()
