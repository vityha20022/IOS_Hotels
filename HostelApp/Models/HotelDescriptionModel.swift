//
//  HotelDescriptionModel.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 12.11.2022.
//

import Foundation

struct HotelDescription: Codable {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    let suitesAvailability: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case stars
        case distance
        case suitesAvailability = "suites_availability"
    }
}
