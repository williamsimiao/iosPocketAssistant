//
//  DrawerHeaderViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 03/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class DrawerHeaderViewController: UIViewController,MDCBottomDrawerHeader {
    //    let preferredHeight: CGFloat = 60
    //    let titleLabel : UILabel = {
    //        let label = UILabel(frame: .zero)
    //        label.text = "Menu"
    //        label.sizeToFit()
    //        return label
    //    }()
    //
    //    override var preferredContentSize: CGSize {
    //        get {
    //            return CGSize(width: view.bounds.width, height: preferredHeight)
    //        }
    //        set {
    //            super.preferredContentSize = newValue
    //        }
    //    }
    //
    //    init() {
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //    }
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        view.addSubview(titleLabel)
    //    }
    //
    //    override func viewWillLayoutSubviews() {
    //        view.backgroundColor = UIColor(red: 56, green: 69, blue: 76)
    //
    //        super.viewWillLayoutSubviews()
    //        titleLabel.font = MDCTypography.titleFont()
    //        titleLabel.alpha = MDCTypography.titleFontOpacity()
    //        titleLabel.textColor = .white
    //        titleLabel.contentMode = .left
    //        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    //
    //        titleLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.height / 2)
    ////
    //        NSLayoutConstraint.activate([
    //            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 4),
    //            titleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
    //            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
    //            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
    //            ])
    //    }
}
