//
//  ObjetosViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 23/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit

class ObjetosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tokenString: String?
    var objIdArray: [String]?
    var networkManager: NetworkManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension ObjetosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowCounter = objIdArray?.count else {
            return 0
        }
        return rowCounter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        guard let data = objIdArray else {
            return  cell
        }
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    
}
