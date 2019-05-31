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
    var separator: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = MDCTypography.body2Font()
        titleLabel.alpha = MDCTypography.body2FontOpacity()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ])
        self.titleLabel = titleLabel
        self.reset()
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
