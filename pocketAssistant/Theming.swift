//
//  Theming.swift
//  pocketAssistant
//
//  Created by William on 29/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import MaterialComponents

func globalContainerScheme() -> MDCContainerScheming {
    let containerScheme = MDCContainerScheme()
    // Customize containerScheme here...
    containerScheme.colorScheme.primaryColor = .black
//
//    // Or assign a customized scheme instance:
//    let shapeScheme = MDCShapeScheme()
//    containerScheme.shapeScheme = shapeScheme
    
    return containerScheme
}

// You can now access your global theme throughout your app:
//    let containerScheme = globalContainerScheme()
