//
//  OptionsCollectionCell.swift
//  pocketAssistant
//
//  Created by William Simiao on 08/08/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
class OptionsCollectionViewCell: MDCCardCollectionCell {
    static var identifier: String = "Cell"
    var separator: UIBezierPath!
    var optionTitle : String? {
        didSet {
            titleLabel.text = optionTitle
        }
    }
    
    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.darkGray
        lbl.font = MDCTypography.subheadFont()
        lbl.alpha = MDCTypography.subheadFontOpacity()
        return lbl
    }()
    
    let arraowImage : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "baseline_keyboard_arrow_right_black_24pt_")
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(arraowImage)
        self.cornerRadius = 4
        self.setShadowElevation(ShadowElevation(1), for: .normal)
//
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowRadius = CGFloat(3)
//        self.layer.shadowOpacity = 0.24
        
        arraowImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.trailingAnchor.constraint(equalTo: arraowImage.trailingAnchor, constant: 8),
            arraowImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            arraowImage.widthAnchor.constraint(equalTo: arraowImage.heightAnchor, multiplier: 1),
            arraowImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.arraowImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ])
    }
}
