//
//  ObjetosViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 23/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftKeychainWrapper

class ObjetosViewController: UICollectionViewController {
    
    var tokenString: String?
    var objIdArray: [String]?
    var networkManager: NetworkManager!
    let certificateTypeInteger = 13
    var certificateCounter = 0
    var exportedCertificates = 0
//    var certificateDataArray: [Data]?
    var certificateNameArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        makeRequest()
        setUpBarButtonItens()

    }
    
    func setUpBarButtonItens() {
        let refreshButton = UIButton(type: .custom)
        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        refreshButton.addTarget(self, action: #selector(ObjetosViewController.didTapAddRefresh), for: .touchUpInside)
        let refreshBarItem = UIBarButtonItem(customView: refreshButton)
        
        self.navigationItem.setRightBarButtonItems([refreshBarItem], animated: true)
    }
    
    @objc func didTapAddRefresh() {
        makeRequest()
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func makeRequestExport(objId: String) {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        NetworkManager().runObjExp(objId: objId, token: token) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                let certificate = SecCertificateCreateWithData(nil, response as CFData)
                let certificateString = String(describing: certificate)
                print("OK: \(certificateString)")
                let matched = self.matches(for: "(?<=s: )(.*)(?= i:)", in: certificateString)
                self.exportedCertificates = self.exportedCertificates + 1
                self.certificateNameArray.append(matched.first!)
                
                
                var commonNamePointer = UnsafeMutablePointer<CFString?>.allocate(capacity: 50)

//                if #available(iOS 10.3, *) {
//                    var cerror: Unmanaged<CFError>?
//                    guard let dict = SecCertificateCopyValues(certificate,nil,&cerror) else {
//                        print("deu ruim")
//                        return
////                        throw cerror!.takeRetainedValue() as Error
//                    }
//                    print("DIC: \(dict)")
//
//                } else {
//                    // Fallback on earlier versions
//                }
            }
            if self.exportedCertificates == self.certificateCounter {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    func makeRequestInfo(objId: String) {
        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        NetworkManager().runGetObjInfo(objId: objId, token: token) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                let myType = response.type
                if myType == self.certificateTypeInteger {
                    self.makeRequestExport(objId: objId)
                    self.certificateCounter = self.certificateCounter + 1
                }
            }
        }
    }
    
    func makeRequest() {
        //TODO:Reset others possible helper variables
        self.certificateCounter = 0
        self.exportedCertificates = 0
        self.certificateNameArray.removeAll()

        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        NetworkManager().runListObjs(token: token) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = response {
                self.objIdArray = response.obj
                for objectId in self.objIdArray! {
                    self.makeRequestInfo(objId: objectId)
                }
            }
        }
    }
}

//Delegate, DataSource
extension ObjetosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width

        return CGSize(width: width, height: 50.0)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rowCounter = certificateNameArray.count
        return rowCounter
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ObjetoCell.identifier, for: indexPath) as! ObjetoCell
        let data = certificateNameArray
        cell.keyLabel.text = data[indexPath.row]
        return cell
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
