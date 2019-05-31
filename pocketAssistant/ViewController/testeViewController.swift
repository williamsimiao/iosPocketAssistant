//
//  testeViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 30/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//
import UIKit
import MaterialComponents

class testeViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource {
    let listObjetosInfo = DrawerCellinfo(title: "Listar Objetos")
    let outraCoisaInfo = DrawerCellinfo(title: "Outra coisa")
    var drawerItens: [DrawerCellinfo]!
    
    let collectionView: UICollectionView
    let layout = UICollectionViewFlowLayout()
    
    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawerItens = [listObjetosInfo, outraCoisaInfo]
        
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
        let width = self.view.frame.size.width
        layout.itemSize = CGSize(width: width, height: 50.0)
        self.preferredContentSize = CGSize(width: view.bounds.width,
                                           height: layout.collectionViewContentSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = drawerItens.count
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawerCell.identifier, for: indexPath) as! DrawerCell
        cell.titleLabel.text = drawerItens[indexPath.row].title
        cell.backgroundColor = .white
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
