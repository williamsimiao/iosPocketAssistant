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
import Security
import ASN1Decoder

class ObjetosViewController: UICollectionViewController {
    
    var tokenString: String?
    var objIdArray: [String]?
    var networkManager: NetworkManager!
    let certificateTypeInteger = 13
    var certificateCounter = 0
    var exportedCertificates = 0
    var certificateArray = [certificate]()
    
    let noContentLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = MDCTypography.titleFont()
        lbl.alpha = MDCTypography.titleFontOpacity()
        lbl.text = "Nenhum certificado listado"
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Certificados"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        makeRequest()
        setUpBarButtonItens()
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(noContentLabel) 
        noContentLabel.textAlignment = .center
        noContentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noContentLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noContentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
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
        NetworkManager().runObjExp(myDelegate: self, objId: objId, token: token) { (response, errorResponse) in
            if let errorResponse = errorResponse {
                let message = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
                let snackBar = MDCSnackbarMessage()
                snackBar.text = message
                MDCSnackbarManager.show(snackBar)
            }
            if let response = response {
                do {
                    let x509 = try X509Certificate(data: response as Data)

                    let subject = x509.subjectDistinguishedName
                    let beginIndex = subject?.firstIndex(of: "=")
                    let realBeginIndex = subject!.index(beginIndex!, offsetBy: 1)
                    let endIndex = subject?.firstIndex(of: ",") ?? subject?.endIndex

                    let name = String(subject![realBeginIndex..<endIndex!])

                    let issuer = x509.issuerDistinguishedName
                    let issuerBeginIndex = issuer?.firstIndex(of: "=")
                    let issuerRealBeginIndex = issuer!.index(issuerBeginIndex!, offsetBy: 1)
                    let issuerEndIndex = issuer?.firstIndex(of: ",") ?? issuer?.endIndex

                    let issuerName = String(issuer![issuerRealBeginIndex..<issuerEndIndex!])

                    let mCert = certificate(name: name, issuer: issuerName, notBefore: x509.notBefore!, notAfter: x509.notAfter!)
                    self.certificateArray.append(mCert)

                } catch {
                    print(error)
                }
                self.exportedCertificates = self.exportedCertificates + 1

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
        NetworkManager().runGetObjInfo(myDelegate: self, objId: objId, token: token) { (response, error) in
            if let error = error {
                let message = AppUtil.handleAPIError(viewController: self, mErrorBody: error)
                let snackBar = MDCSnackbarMessage()
                snackBar.text = message
                MDCSnackbarManager.show(snackBar)
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
        self.certificateArray.removeAll()

        guard let token = KeychainWrapper.standard.string(forKey: "TOKEN") else {
            return
        }
        NetworkManager().runListObjs(myDelegate: self, token: token) { (response, errorResponse) in
            if let errorResponse = errorResponse {
                let message = AppUtil.handleAPIError(viewController: self, mErrorBody: errorResponse)
                let snackBar = MDCSnackbarMessage()
                snackBar.text = message
                MDCSnackbarManager.show(snackBar)
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

        return CGSize(width: width, height: 108.0)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rowCount = certificateArray.count
        if(rowCount == 0) {
            self.noContentLabel.isHidden = false
        }
        else {
            self.noContentLabel.isHidden = true
        }
        
        return rowCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ObjetoCell.identifier, for: indexPath) as! ObjetoCell
        cell.aCertificate = certificateArray[indexPath.row]
        return cell
    }
    
    @objc func backItemTapped(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ObjetosViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("AQUIIIIII")
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            print("Olha o IP \(challenge.protectionSpace.host)")
            let myHost = KeychainWrapper.standard.string(forKey: "BASE_URL")!
            if(challenge.protectionSpace.host == myHost) {
                print("LALA")
                let secTrust = challenge.protectionSpace.serverTrust
                let credential = URLCredential(trust: secTrust!)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            }
        }
    }
}
