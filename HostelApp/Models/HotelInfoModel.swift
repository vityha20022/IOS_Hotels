//
//  HotelInfoModel.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 14.11.2022.
//

import Foundation
struct HotelInfo: Codable {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    let image: String?
    let suitesAvailability: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case stars
        case distance
        case image
        case suitesAvailability = "suites_availability"
        case lat
        case lon
    }
}
