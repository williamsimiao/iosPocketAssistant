//
//  ObjetosCell.swift
//  pocketAssistant
//
//  Created by William Simiao on 27/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import MaterialComponents

class ObjetoCell: MDCCardCollectionCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    
    var separator: UIBezierPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        keyLabel.font = MDCTypography.body2Font()
        keyLabel.alpha = MDCTypography.body2FontOpacity()

    }


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createRectangle()

    }
    
    
    func createRectangle() {
        // Initialize the path.
        separator = UIBezierPath()
        
        // Create the bottom line (bottom-left to bottom-right).
        separator.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
        separator.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        separator.close()
        UIColor.black.setStroke()
        separator.stroke()
    }

}
