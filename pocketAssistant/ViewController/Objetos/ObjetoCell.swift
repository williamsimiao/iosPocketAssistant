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
    static var identifier: String = "Cell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var issuerLabel: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    
    
    var separator: UIBezierPath!
    var aCertificate: certificate? {
        didSet {
            nameLabel.text = aCertificate?.name
            issuerLabel.text = aCertificate?.issuer
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            fromDate.text = dateFormatter.string(from: aCertificate!.notBefore)
            toDate.text = dateFormatter.string(from: aCertificate!.notAfter)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = MDCTypography.body1Font()
        nameLabel.alpha = MDCTypography.titleFontOpacity()
        
        issuerLabel.font = MDCTypography.body1Font()
        issuerLabel.alpha = MDCTypography.body1FontOpacity()
        
        fromDate.font = MDCTypography.body1Font()
        fromDate.alpha = MDCTypography.body1FontOpacity()
        
        toDate.font = MDCTypography.body1Font()
        toDate.alpha = MDCTypography.body1FontOpacity()
        
        fromLabel.font = MDCTypography.body1Font()
        fromLabel.alpha = MDCTypography.titleFontOpacity()
        
        toLabel.font = MDCTypography.body1Font()
        toLabel.alpha = MDCTypography.body2FontOpacity()

        
//        arrowImage.image = UIImage(named: "baseline_keyboard_arrow_right_black_24pt_")
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
