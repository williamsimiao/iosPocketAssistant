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
    var userPermission : item? {
        didSet {
            titleLabel.text = userPermission?.usr
        }
    }
    
    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = MDCTypography.body1Font()
        lbl.alpha = MDCTypography.body1FontOpacity()
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
        arraowImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            self.contentView.trailingAnchor.constraint(equalTo: arraowImage.trailingAnchor, constant: 8),
            arraowImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            arraowImage.widthAnchor.constraint(equalTo: arraowImage.heightAnchor, multiplier: 1),
            arraowImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.arraowImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ])
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
