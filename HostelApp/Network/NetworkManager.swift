//
//  NetworkManager.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 13.11.2022.
//

import Foundation
import UIKit

enum HotelDescriptionsResult {
    case success(hotelDescriptions: [HotelDescription])
    case failure(error: String)
}

enum HotelInfoResult {
    case success(hotelInfo: HotelInfo)
    case failure(error: String)
}

enum HotelImageResult {
    case success(hotelImage: UIImage)
    case failure(error: String)
}

class NetworkManager {
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()

    func obtainHotelDescriptions(completion: @escaping (HotelDescriptionsResult) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json") else {
            return
        }

        session.dataTask(with: url) { [weak self] data, _, error in
            var result: HotelDescriptionsResult

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

    func obtainHotelInfoForDescriptionId(id: String, completion: @escaping (HotelInfoResult) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/\(id).json") else {
            return
        }

        session.dataTask(with: url) { [weak self] data, _, error in
            var result: HotelInfoResult

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

            guard let hotelInfo = try? strongSelf.decoder.decode(HotelInfo.self, from: data) else {
                result = .failure(error: "Error JSON decoding")
                return
            }

            result = .success(hotelInfo: hotelInfo)
        }.resume()
    }

    func obtainHotelImageForImageId(id: String, completion: @escaping (HotelImageResult) -> Void) {
        guard let url = URL(string: "https://github.com/iMofas/ios-android-test/raw/master/\(id).jpg") else {
            return
        }

        session.dataTask(with: url) { data, _, error in
            var result: HotelImageResult

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            guard let data = data, error == nil else {
                result = .failure(error: "Downloading error")
                return
            }

            /*guard let hotelInfo = try? strongSelf.decoder.decode(HotelInfo.self, from: data) else {
                result = .failure(error: "Error JSON decoding")
                return
            }*/
            guard let image = UIImage(data: data) else {
                result = .failure(error: "Incorrect image data error")
                return
            }

            result = .success(hotelImage: image)

        }.resume()
    }
}
