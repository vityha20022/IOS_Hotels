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
        
        networkManager.obtainHotelDescriptions { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingSpinner.stopAnimating()

                switch result {
                    case .success(let hotelDescriptions):
                        let hotelsVC = self?.storyboard?.instantiateViewController(withIdentifier: "HotelsTableViewController") as! HotelsTableViewController
                        hotelsVC.hotelDescriptions = hotelDescriptions
                        self?.navigationController?.pushViewController(hotelsVC, animated: true)
                    case .failure(_):
                        sender.isHidden = false
                        self?.errorLabel.isHidden = false
                        self?.tipLabel.isHidden = false
                }
            }
        }
    }
}

