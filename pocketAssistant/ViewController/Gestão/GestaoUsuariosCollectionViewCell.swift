//
//  GestaoUsuariosCollectionViewCell.swift
//  pocketAssistant
//
//  Created by William Simiao on 06/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

protocol gestaoUsuariosCellDelegate {
    func onDeleteTapped(userName: String)
    func onEditTapped(userName: String)
}

class GestaoUsuariosCollectionViewCell: MDCCardCollectionCell {
    static var identifier: String = "Cell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var separator: UIBezierPath!
    
    var userName: String? {
        didSet {
            titleLabel.text = userName
        }
    }
    
    var actionDelegate: gestaoUsuariosCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = MDCTypography.subheadFont()
        titleLabel.alpha = MDCTypography.subheadFontOpacity()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createRectangle()
    }
    
    @IBAction func didTapEdit(_ sender: Any) {
        actionDelegate?.onEditTapped(userName: self.userName!)
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        actionDelegate?.onDeleteTapped(userName: self.userName!)
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
