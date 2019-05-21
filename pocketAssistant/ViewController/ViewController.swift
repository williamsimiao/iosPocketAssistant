//
//  ViewController.swift
//  pocketAssistant
//
//  Created by William Simiao on 13/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var networkManager: NetworkManager!
    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.networkManager = NetworkManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .green
        
        networkManager.getMovieRecomendationsById(id: 550) { (movies, error) in
            if let error = error {
                print(error)
            }
            if let movies = movies {
                for singleMovie in movies {
                    print(singleMovie.title)
                }
            }
        }
        
        networkManager.getNewMovies(page: 1) { (movies, error) in
            if let error = error {
                print(error)
            }
            if let movies = movies {
                for singleMovie in movies {
                    print("\(singleMovie.title)")
                }
            }
        }
        
    }
}

