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
    var separator: UIBezierPath!
    
    var myItem : item? {
        didSet {
            titleLabel.text = myItem?.usr
        }
    }
    
    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = MDCTypography.body2Font()
        lbl.alpha = MDCTypography.body2FontOpacity()
        return lbl
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
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
//            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 8)
//            ])
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
