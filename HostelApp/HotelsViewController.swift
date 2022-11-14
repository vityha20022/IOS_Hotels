//
//  HotelViewController.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 14.11.2022.
//

import UIKit


class HotelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let networkManager = NetworkManager()
    var hotelDescriptionsWithSorting: [HotelDescription]!
    var unsortedDescriptions: [HotelDescription]!
    var imageByHotelInfoId = [Int?: UIImage]()
    var hotelInfoByDescriptionId = [Int: HotelInfo]()
    
    enum SortingType {
        case NoSorting
        case ByDistance
        case ByRooms
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupSortingControl()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Hotels"
    }
    
    func setupSortingControl() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "No sorting", image: nil, handler: { [weak self] (_) in self?.sortModel(sortType: .NoSorting)
                }),
                UIAction(title: "By distance", image: nil, handler: { [weak self] (_) in self?.sortModel(sortType: .ByDistance)
                }),
                UIAction(title: "By rooms", image: nil, handler: { [weak self] (_) in self?.sortModel(sortType: .ByRooms)
                })
            ]
        }

        var demoMenu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(named: "sort"), primaryAction: nil, menu: demoMenu)
    }
    
    func sortModel(sortType: SortingType) {
        switch sortType {
            case .NoSorting:
                hotelDescriptionsWithSorting = unsortedDescriptions
            case .ByDistance:
                hotelDescriptionsWithSorting = unsortedDescriptions.sorted(by: { first, second in
                    first.distance < second.distance
                })
            case .ByRooms:
                hotelDescriptionsWithSorting = unsortedDescriptions.sorted(by: { first, second in
                    getNumberAvailableRoomsFor(hotel: first) > getNumberAvailableRoomsFor(hotel: second)
                })
        }
        
        tableView.reloadData()
    }
    
    func getNumberAvailableRoomsFor(hotel: HotelDescription) -> Int {
        let suitesAvailability = hotel.suitesAvailability
        return suitesAvailability.split(separator: ":").count
    }
    
    func croppedImageBordersFor(image: UIImage, pixelsToCrop offset: Double) -> UIImage {
        let cropRect = CGRect(x: offset, y: offset, width: image.size.width - offset - 2 * offset, height: image.size.height - 2 * offset)
        let sourceCGImage = image.cgImage!
        let croppedCGImage = sourceCGImage.cropping(to: cropRect)!
        let croppedImage = UIImage(cgImage: croppedCGImage, scale: image.imageRendererFormat.scale, orientation: image.imageOrientation)
        return croppedImage
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotelDescriptionsWithSorting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hotelDescription = hotelDescriptionsWithSorting[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelCell", for: indexPath) as! HotelTableViewCell
        
        // set text values
        cell.hotelNameLabel.text = hotelDescription.name
        cell.hotelStarsLabel.text = String(hotelDescription.stars)
        cell.hotelAddressLabel.text = hotelDescription.address
        cell.hotelDistanceToCityCenterLabel.text = "\(hotelDescription.distance) meters to city center"
        cell.hotelAvailableRoomsLabel.text = "\(getNumberAvailableRoomsFor(hotel: hotelDescription)) available rooms now"
        
        // set image
        guard let hotelInfo = hotelInfoByDescriptionId[hotelDescription.id] else {
            cell.imageLoadingSpinner.startAnimating()
            networkManager.obtainHotelInfoForDescriptionId(id: String(hotelDescription.id)) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        case.success(let info):
                            self?.hotelInfoByDescriptionId[hotelDescription.id] = info
                            self?.setImageForCellByInfo(cell: cell, info: info)
                        case.failure(_):
                            self?.setImageForCell(cell: cell, image: UIImage(named: "noImage")!, hotelInfoId: nil)
                    }
                }
            }
            
            return cell
        }
        
        let image = imageByHotelInfoId[hotelInfo.id]
        cell.hotelImage.image = image
        
        return cell
    }
    
    func setImageForCellByInfo(cell: HotelTableViewCell, info: HotelInfo) {
        guard let imagePath = info.image else {
            setImageForCell(cell: cell, image: UIImage(named: "noImage")!, hotelInfoId: info.id)
            return
        }
        
        let parsedImagePath = imagePath.split(separator: ".")
        
        guard parsedImagePath.count != 0 else {
            setImageForCell(cell: cell, image: UIImage(named: "noImage")!, hotelInfoId: info.id)
            return
        }
        
        let imageId = String(parsedImagePath[0])
        
        networkManager.obtainHotelImageForImageId(id: imageId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case.success(let image):
                        let croppedImage = self?.croppedImageBordersFor(image: image, pixelsToCrop: 1.0)
                        self?.setImageForCell(cell: cell, image: croppedImage!, hotelInfoId: info.id)
                    case.failure(_):
                        self?.setImageForCell(cell: cell, image: UIImage(named: "noImage")!, hotelInfoId: info.id)
                }
            }
        }
    }
    
    func setImageForCell(cell: HotelTableViewCell, image: UIImage, hotelInfoId: Int?) {
        imageByHotelInfoId[hotelInfoId] = image
        cell.imageLoadingSpinner.stopAnimating()
        cell.hotelImage.image = image
    }

        

}
