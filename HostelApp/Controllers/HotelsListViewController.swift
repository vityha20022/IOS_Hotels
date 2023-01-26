//
//  HotelViewController.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 14.11.2022.
//

import UIKit

class HotelsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var networkManager: NetworkManager!
    var hotelDescriptionsWithSorting: [HotelDescription]!
    var unsortedDescriptions: [HotelDescription]!
    var imageByHotelInfoId = [Int?: UIImage]()
    var hotelInfoByHotelDescriptionId = [Int: HotelInfo]()

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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.title = "Hotels"
    }

    func setupSortingControl() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "No sorting", image: nil,
                         handler: { [weak self] (_) in self?.sortModel(sortType: .NoSorting)}),

                UIAction(title: "By distance", image: nil,
                         handler: { [weak self] (_) in self?.sortModel(sortType: .ByDistance)}),

                UIAction(title: "By rooms", image: nil,
                         handler: { [weak self] (_) in self?.sortModel(sortType: .ByRooms)})
            ]
        }

        var demoMenu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(named: "sort"),
                                                            primaryAction: nil, menu: demoMenu)
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
                first.suitesAvailability.getNumberAvailableRooms() >
                second.suitesAvailability.getNumberAvailableRooms()
            })
        }

        tableView.reloadData()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hotelDescription = hotelDescriptionsWithSorting[indexPath.row]

        guard let hotelInfo = hotelInfoByHotelDescriptionId[hotelDescription.id] else {
            return
        }

        guard let hotelImage = imageByHotelInfoId[hotelInfo.id] else {
            return
        }

        let hotelPageVC = storyboard?.instantiateViewController(withIdentifier: "HotelPageViewController") as! HotelPageViewController
        hotelPageVC.hotelImage = hotelImage
        hotelPageVC.hotelInfo = hotelInfo
        navigationController?.pushViewController(hotelPageVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hotelDescription = hotelDescriptionsWithSorting[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelCell", for: indexPath) as! HotelTableViewCell

        setTextValuesForCellByHotelDescription(cell: cell, description: hotelDescription)
        setImageForCellByHotelDescription(cell: cell, description: hotelDescription)

        return cell
    }

    func setTextValuesForCellByHotelDescription(cell: HotelTableViewCell, description: HotelDescription) {
        cell.hotelNameLabel.text = description.name
        cell.hotelStarsLabel.text = String(description.stars)
        cell.hotelAddressLabel.text = description.address
        cell.hotelDistanceToCityCenterLabel.text = "\(description.distance) meters to city center"
        cell.hotelAvailableRoomsLabel.text = "\(description.suitesAvailability.getNumberAvailableRooms()) available rooms now"
    }

    func setImageForCellByHotelDescription(cell: HotelTableViewCell, description: HotelDescription) {
        guard let hotelInfo = hotelInfoByHotelDescriptionId[description.id] else {
            cell.hotelImage.image = nil // set to nil to work correctly immediately after sorting
            cell.imageLoadingSpinner.startAnimating()

            networkManager.obtainHotelInfoForDescriptionId(id: String(description.id)) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case.success(let info):
                        self?.hotelInfoByHotelDescriptionId[description.id] = info
                        self?.setImageForCellByHotelInfo(cell: cell, info: info)
                    case.failure:
                        self?.setAndCacheImageForCell(cell: cell, image: UIImage(systemName: "circle.slash")!, hotelInfoId: nil)
                    }
                }
            }

            return
        }

        let image = imageByHotelInfoId[hotelInfo.id]
        cell.hotelImage.image = image
    }

    func setImageForCellByHotelInfo(cell: HotelTableViewCell, info: HotelInfo) {
        guard let imagePath = info.image else {
            setAndCacheImageForCell(cell: cell, image: UIImage(systemName: "circle.slash")!, hotelInfoId: info.id)
            return
        }

        let parsedImagePath = imagePath.split(separator: ".")

        guard !parsedImagePath.isEmpty else {
            setAndCacheImageForCell(cell: cell, image: UIImage(systemName: "circle.slash")!, hotelInfoId: info.id)
            return
        }

        let imageId = String(parsedImagePath[0])

        networkManager.obtainHotelImageForImageId(id: imageId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let image):
                    let croppedImage = image.croppedImageBorders(pixelsToCrop: 1.0)
                    self?.setAndCacheImageForCell(cell: cell, image: croppedImage, hotelInfoId: info.id)
                case.failure:
                    self?.setAndCacheImageForCell(cell: cell, image: UIImage(systemName: "circle.slash")!, hotelInfoId: info.id)
                }
            }
        }
    }

    func setAndCacheImageForCell(cell: HotelTableViewCell, image: UIImage, hotelInfoId: Int?) {
        imageByHotelInfoId[hotelInfoId] = image
        cell.imageLoadingSpinner.stopAnimating()
        cell.hotelImage.image = image
    }
}
