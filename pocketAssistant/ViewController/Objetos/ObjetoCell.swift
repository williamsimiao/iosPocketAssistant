//
//  ObjetosCell.swift
//  pocketAssistant
//
//  Created by William Simiao on 27/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation
import MaterialComponents

class ObjetoCell: MDCBaseCell {
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
//        lerLabel.font = MDCTypography.subheadFont()
//        lerLabel.alpha = MDCTypography.subheadFontOpacity()
//        lerSubLabel.font = MDCTypography.subheadFont()
//        lerSubLabel.alpha = MDCTypography.captionFontOpacity()
        
        nameLabel.font = MDCTypography.subheadFont()
        nameLabel.alpha = MDCTypography.subheadFontOpacity()
        
        issuerLabel.font = MDCTypography.subheadFont()
        issuerLabel.alpha = MDCTypography.captionFontOpacity()
        
        fromDate.font = MDCTypography.subheadFont()
        fromDate.alpha = MDCTypography.captionFontOpacity()
        
        toDate.font = MDCTypography.subheadFont()
        toDate.alpha = MDCTypography.captionFontOpacity()
        
        fromLabel.font = MDCTypography.subheadFont()
        fromLabel.alpha = MDCTypography.subheadFontOpacity()
        
        toLabel.font = MDCTypography.subheadFont()
        toLabel.alpha = MDCTypography.subheadFontOpacity()

        
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
