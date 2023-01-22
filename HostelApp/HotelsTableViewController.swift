//
//  HostelsTableViewController.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 13.11.2022.
//

import UIKit

class HotelsTableViewController: UITableViewController {
    var hotelDescriptions: [HotelDescription]!
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
    }

    func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Hotels"
        /*self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false;*/
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotelDescriptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hotelDescription = hotelDescriptions[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelCell", for: indexPath) as! HotelTableViewCell

        cell.imageLoadingSpinner.startAnimating()

        cell.hotelNameLabel.text = hotelDescription.name
        cell.hotelStarsLabel.text = String(hotelDescription.stars)
        cell.hotelAddressLabel.text = hotelDescription.address
        cell.hotelDistanceToCityCenterLabel.text = "\(hotelDescription.distance) meters to city center"
        cell.hotelAvailableRoomsLabel.text = "\(getNumberAvailableRoomsFor(hotel: hotelDescription)) available rooms now"

        networkManager.obtainHotelInfoForDescriptionId(id: String(hotelDescription.id)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let info):
                    self?.setImageForCellByInfo(cell: cell, info: info)
                case.failure:
                    print("fail") // TODO
                }
            }
        }

        return cell

    }

    func setImageForCellByInfo(cell: HotelTableViewCell, info: HotelInfo?) {
        guard let info = info else {
            setImageForCell(cell: cell, image: UIImage(named: "noImage")!)
            return
        }

        guard let imagePath = info.image else {
            setImageForCell(cell: cell, image: UIImage(named: "noImage")!)
            return
        }

        let parsedImagePath = imagePath.split(separator: ".")

        guard !parsedImagePath.isEmpty else {
            setImageForCell(cell: cell, image: UIImage(named: "noImage")!)
            return
        }

        let imageId = String(parsedImagePath[0])

        networkManager.obtainHotelImageForImageId(id: imageId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let image):
                    let croppedImage = self?.croppedImageBordersFor(image: image, pixelsToCrop: 1.0)
                    self?.setImageForCell(cell: cell, image: croppedImage!)
                case.failure:
                    self?.setImageForCell(cell: cell, image: UIImage(named: "noImage")!)
                }
            }
        }

    }

    func setImageForCell(cell: HotelTableViewCell, image: UIImage) {
        cell.imageLoadingSpinner.stopAnimating()
        cell.hotelImage.image = image
    }

}
