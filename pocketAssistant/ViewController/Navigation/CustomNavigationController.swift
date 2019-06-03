//
//  CustomNavigationController.swift
//  pocketAssistant
//
//  Created by William Simiao on 30/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

public enum drawerKeys : String {
    case drawerMenu = "drawerMenu"
    case sections = "sections"
    case section = "section"
    case sectionTitle = "sectionTitle"
    case cellItens = "cellItens"
    case title = "title"
    case leftImageName = "leftImageName"
}

class CustomNavigationController: UINavigationController {

    @objc var colorScheme = MDCSemanticColorScheme()
    let bottomAppBar = MDCBottomAppBarView()
    
    let headerViewController = DrawerHeaderViewController()
    let contentViewController = DrawerContentWithScrollViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorScheme.backgroundColor
        
        bottomAppBar.isFloatingButtonHidden = true
        let barButtonLeadingItem = UIBarButtonItem()
        let menuImage = UIImage(named:"baseline_menu_black_24pt_")?.withRenderingMode(.alwaysTemplate)
        barButtonLeadingItem.image = menuImage
        barButtonLeadingItem.target = self
        barButtonLeadingItem.action = #selector(presentNavigationDrawer)
        bottomAppBar.leadingBarButtonItems = [ barButtonLeadingItem ]
        
        let barButtonTrailingItem = UIBarButtonItem()
        let userImage = UIImage(named:"baseline_person_black_24pt_")?.withRenderingMode(.alwaysTemplate)
        barButtonTrailingItem.image = userImage
        barButtonTrailingItem.target = self
        barButtonTrailingItem.action = #selector(presentPerfilController)
        bottomAppBar.trailingBarButtonItems = [ barButtonTrailingItem ]
        
        MDCBottomAppBarColorThemer.applySurfaceVariant(withSemanticColorScheme: colorScheme,
                                                       to: bottomAppBar)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeOnBottomAppBar))
        bottomAppBar.addGestureRecognizer(swipeGestureRecognizer)
        view.addSubview(bottomAppBar)
    }
    @objc func didSwipeOnBottomAppBar(sender: UIGestureRecognizer) {
        
    }
    
    private func layoutBottomAppBar() {
        let size = bottomAppBar.sizeThatFits(view.bounds.size)
        var bottomBarViewFrame = CGRect(x: 0,
                                        y: view.bounds.size.height - size.height,
                                        width: size.width,
                                        height: size.height)
        if #available(iOS 11.0, *) {
            bottomBarViewFrame.size.height += view.safeAreaInsets.bottom
            bottomBarViewFrame.origin.y -= view.safeAreaInsets.bottom
        }
        bottomAppBar.frame = bottomBarViewFrame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutBottomAppBar()
    }
    
    @objc func presentPerfilController() {
        let stor = UIStoryboard.init(name: "Main", bundle: nil)
        let mainViewController = stor.instantiateViewController(withIdentifier: "PerfilViewController")
        self.present(mainViewController, animated: true, completion: { () in
            print("Done")
        })
    }
    
    @objc func presentNavigationDrawer() {
        let bottomDrawerViewController = MDCBottomDrawerViewController()
        bottomDrawerViewController.maximumInitialDrawerHeight = 400;

        bottomDrawerViewController.contentViewController = contentViewController
        bottomDrawerViewController.headerViewController = headerViewController
        bottomDrawerViewController.trackingScrollView = contentViewController.collectionView
        MDCBottomDrawerColorThemer.applySemanticColorScheme(colorScheme,
                                                            toBottomDrawer: bottomDrawerViewController)
        present(bottomDrawerViewController, animated: true, completion: nil)
    }
}

class DrawerContentWithScrollViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource {
    
    let collectionView: UICollectionView
    let layout = UICollectionViewFlowLayout()
    
    //particao
    let chavesItem = cellInfo(title: "Chaves/Objetos", leftImageName: "baseline_vpn_key_white_24pt_")
    let confiancaItem = cellInfo(title: "Relação de confiança", leftImageName: "baseline_vpn_key_white_24pt_")
    var particaoSection: section?
    //usuarios
    let gestaoItem = cellInfo(title: "Gestão", leftImageName: "baseline_vpn_key_white_24pt_")
    var usuariosSection: section?
    
    var drawerComplete: drawerMenu?

    
    init() {
        particaoSection = section(sectionTitle: "Partição", cellItens: [chavesItem, confiancaItem])
        usuariosSection = section(sectionTitle: "Usuários", cellItens: [gestaoItem])
        drawerComplete = drawerMenu(sections: [particaoSection!, usuariosSection!])

        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                      height: self.view.bounds.height)
        collectionView.backgroundColor = .orange
        collectionView.register(DrawerCell.self, forCellWithReuseIdentifier: DrawerCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.view.addSubview(collectionView)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.backgroundColor = UIColor(red: 56, green: 69, blue: 76)

        let width = self.view.frame.size.width
        layout.itemSize = CGSize(width: width, height: 50.0)
        self.preferredContentSize = CGSize(width: view.bounds.width,
                                           height: layout.collectionViewContentSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let aSection = drawerComplete?.sections[section]
        
        return aSection!.cellItens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawerCell.identifier, for: indexPath) as! DrawerCell
        
        let section = drawerComplete!.sections[indexPath.section]
        let cellItem = section.cellItens[indexPath.row]
        cell.titleLabel.text = cellItem.title
        cell.imageView.image = UIImage(named: cellItem.leftImageName)

        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sectionCount = drawerComplete?.sections.count else {
            return 0
        }
        return sectionCount
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
}

class DrawerHeaderViewController: UIViewController,MDCBottomDrawerHeader {
    let preferredHeight: CGFloat = 60
    let titleLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Menu"
        label.sizeToFit()
        return label
    }()
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: view.bounds.width, height: preferredHeight)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
    }
    
    override func viewWillLayoutSubviews() {
        view.backgroundColor = UIColor(red: 56, green: 69, blue: 76)

        super.viewWillLayoutSubviews()
        titleLabel.font = MDCTypography.titleFont()
        titleLabel.alpha = MDCTypography.titleFontOpacity()
        titleLabel.textColor = .white
        titleLabel.contentMode = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.height / 2)
//
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
            ])
    }
    
}

