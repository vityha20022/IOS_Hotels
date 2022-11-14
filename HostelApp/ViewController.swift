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
    
    override func viewWillAppear(_ animated: Bool) {
        // restore state after back segue
        self.navigationController?.navigationBar.isHidden = true
        showHotelsButton.isHidden = false
        errorLabel.isHidden = true
        tipLabel.isHidden = true
    }
    
    @IBAction func showHotels(_ sender: UIButton) {
        sender.isHidden = true
        loadingSpinner.startAnimating()
        
        networkManager.obtainHotelDescriptions { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingSpinner.stopAnimating()

                switch result {
                    case .success(let hotelDescriptions):
                        let hotelsVC = self?.storyboard?.instantiateViewController(withIdentifier: "HotelsViewController") as! HotelsViewController
                        hotelsVC.hotelDescriptionsWithSorting = hotelDescriptions
                        hotelsVC.unsortedDescriptions = hotelDescriptions
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

