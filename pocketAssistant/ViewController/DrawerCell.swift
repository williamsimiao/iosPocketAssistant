//
//  DrawerCell.swift
//  pocketAssistant
//
//  Created by William Simiao on 31/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class DrawerCell: MDCCardCollectionCell {
    static var identifier: String = "DrawerCell"
    weak var titleLabel: UILabel!
    weak var imageView: UIImageView!
    var separator: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 56, green: 69, blue: 76)
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .center
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = MDCTypography.body1Font()
        titleLabel.alpha = MDCTypography.body1FontOpacity()
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white


        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(imageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel = titleLabel
        self.imageView = imageView
        
        NSLayoutConstraint.activate([
            //imageView
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1, constant: 0),
            
            
            //titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            self.contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset() {
        self.titleLabel.textAlignment = .center
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createRectangle()
        
    }
    
    func createRectangle() {
        // Initialize the path.
        separator = UIBezierPath()
        UIColor.lightGray.setStroke()
        separator.lineWidth = 0.5
        // Create the bottom line (bottom-left to bottom-right).
        separator.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
        separator.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        separator.close()
        UIColor.black.setStroke()
        separator.stroke()
    }

}
