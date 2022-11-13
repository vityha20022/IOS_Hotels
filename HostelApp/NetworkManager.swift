//
//  NetworkManager.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 13.11.2022.
//

import Foundation

enum hotelDescriptionsResult {
    case success(hotelDescriptions: [HotelDescription])
    case failure(error: String)
}

class NetworkManager {
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func downloadHotelDescriptions(completion: @escaping (hotelDescriptionsResult) -> Void ) {
        guard let url = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json") else {
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            var result: hotelDescriptionsResult
            
            defer {
                DispatchQueue.main.async {
                    completion(result) 
                }
            }
            
            guard let strongSelf = self else {
                result = .failure(error: "Error create strong ref")
                return
            }
            
            guard let data = data, error == nil else {
                result = .failure(error: "Downloading error")
                return
            }
            
            guard let hotelDescriptions = try? strongSelf.decoder.decode([HotelDescription].self, from: data) else {
                result = .failure(error: "Error JSON decoding")
                return
            }
            
            result = .success(hotelDescriptions: hotelDescriptions)
        }.resume()
    }
}
