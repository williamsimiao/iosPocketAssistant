//
//  SectionView.swift
//  pocketAssistant
//
//  Created by William Simiao on 03/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class SectionView: UICollectionReusableView {
    static var identifier: String = "SectionView"
    var sectionLabel: UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.myCustomInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.myCustomInit()
    }
    
    func myCustomInit() {
        sectionLabel = UILabel(frame: .zero)
        guard let sectionLabel = sectionLabel else {
            return
        }
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.font = MDCTypography.body1Font()
        sectionLabel.alpha = MDCTypography.body1FontOpacity()
        sectionLabel.textAlignment = .left
        sectionLabel.textColor = .white
        
        self.addSubview(sectionLabel)
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            self.trailingAnchor.constraint(equalTo: sectionLabel.trailingAnchor, constant: 4),
            sectionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            sectionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
            ])
    }
    
}
