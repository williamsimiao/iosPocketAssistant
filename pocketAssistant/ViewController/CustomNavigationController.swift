//
//  CustomNavigationController.swift
//  pocketAssistant
//
//  Created by William Simiao on 30/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Same as default
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: MDCTypography.titleFont()]

    }

}
