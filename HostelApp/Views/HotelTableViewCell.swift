//
//  HotelTableViewCell.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 13.11.2022.
//

import UIKit

class HotelTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelStarsLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var hotelDistanceToCityCenterLabel: UILabel!
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var imageLoadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var hotelAvailableRoomsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
