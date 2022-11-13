//
//  ViewController.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 12.11.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var showHotelsButton: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    var hotelDescriptions = [HotelDescription]()
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showHotels(_ sender: UIButton) {
        sender.isHidden = true
        loadingSpinner.startAnimating()
        
        networkManager.downloadHotelDescriptions { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingSpinner.stopAnimating()
                
                sender.isHidden = false
                
                
                switch result {
                    case .success(let hotelDescriptions): break
                    case .failure(let error):
                        self?.errorLabel.isHidden = false
                        self?.tipLabel.isHidden = false
                }
            }
        }
    }
}

