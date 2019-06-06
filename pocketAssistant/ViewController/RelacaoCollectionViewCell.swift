//
//  RelacaoCollectionViewCell.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

//protocol relacaoCollectionCellDelegate {
//    func onDeleteTapped(userName: String)
//    func onEditTapped(userName: String)
//}

class RelacaoCollectionViewCell: MDCCardCollectionCell {
    static var identifier: String = "Cell"
    @IBOutlet weak var titleLabel: UILabel!
    var separator: UIBezierPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = MDCTypography.body2Font()
        titleLabel.alpha = MDCTypography.body2FontOpacity()
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
