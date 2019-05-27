//
//  ObjetosCell.swift
//  pocketAssistant
//
//  Created by William Simiao on 27/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import MaterialComponents

class ProductCell: MDCCardCollectionCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //TODO: Configure the cell properties
        self.backgroundColor = .white
        
        //TODO: Configure the MDCCardCollectionCell specific properties
        self.cornerRadius = 4.0;
        self.setBorderWidth(1.0, for:.normal)
        self.setBorderColor(.lightGray, for: .normal)
    }
}
