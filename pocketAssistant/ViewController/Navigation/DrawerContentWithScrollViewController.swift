//
//  DrawerContentWithScrollViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 03/06/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents

class DrawerContentWithScrollViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource {
    
    let collectionView: UICollectionView
    let flowLayout = UICollectionViewFlowLayout()
    
    //particao
    let chavesItem = cellInfo(title: "Chaves/Objetos", leftImageName: "baseline_vpn_key_white_24pt_")
    let confiancaItem = cellInfo(title: "Relação de confiança", leftImageName: "baseline_vpn_key_white_24pt_")
    var particaoSection: section?
    //usuarios
    let gestaoItem = cellInfo(title: "Gestão", leftImageName: "baseline_vpn_key_white_24pt_")
    var usuariosSection: section?
    
    var drawerComplete: drawerMenuInfo?
    var transitionDelegate: drawerTransitionDelegate?
    var dismissDelegate: drawerDismissDelegate?
    
    init() {
        particaoSection = section(sectionTitle: "Partição", cellItens: [chavesItem, confiancaItem])
        usuariosSection = section(sectionTitle: "Usuários", cellItens: [gestaoItem])
        drawerComplete = drawerMenuInfo(sections: [particaoSection!, usuariosSection!])
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                      height: self.view.bounds.height)
        collectionView.backgroundColor = .orange
        collectionView.register(DrawerCell.self, forCellWithReuseIdentifier: DrawerCell.identifier)
        collectionView.register(SectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 40)
        self.view.addSubview(collectionView)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.backgroundColor = UIColor(red: 56, green: 69, blue: 76)
        
        let width = self.view.frame.size.width
        flowLayout.itemSize = CGSize(width: width, height: 50.0)
        self.preferredContentSize = CGSize(width: view.bounds.width,
                                           height: flowLayout.collectionViewContentSize.height)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dismissDelegate = self.dismissDelegate else {
            print("transition delegate eh ruim")
            return
        }
        dismissDelegate.dismissDrawer()
        
        guard let transitionDelegate = self.transitionDelegate else {
            print("Delegate ruim")
            return
        }
        transitionDelegate.makeTransition(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionView.identifier,
                for: indexPath) as! SectionView
            headerView.sectionLabel?.text = drawerComplete?.sections[indexPath.section].sectionTitle
            
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
}
