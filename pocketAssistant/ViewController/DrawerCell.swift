//
//  DrawerCell.swift
//  pocketAssistant
//
//  Created by William on 30/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

enum drawerTabs: String, CaseIterable {
    case listarObjetos = "LISTAR OBJETOS"
    case criarUsuario =  "CRIAR USUARIO"
    case mudarSenha = "MUDAR SENHA"
    case fecharSessao  = "FECHAR SESSÃO"
}

class DrawerCell: MDCCardCollectionCell {
    var titleLabel: UILabel!
    
    var separator: UIBezierPath!
    var drawerItem:drawerTabs {
        set(newValue) {
            guard let titleLabel = titleLabel else {
                return
            }
            titleLabel.text = newValue.rawValue
        }
        get {
            return self.drawerItem
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: CGRect(x: 0,
                                           y: 0,
                                           width: self.frame.width,
                                           height: self.frame.height))
        contentView.addSubview(titleLabel)
        backgroundColor = .white

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let titleLabel = titleLabel else {
            return
        }
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
        
        // Create the bottom line (bottom-left to bottom-right).
        separator.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
        separator.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        separator.close()
        UIColor.black.setStroke()
        separator.stroke()
    }
}
