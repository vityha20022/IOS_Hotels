//
//  NetworkManager.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 13.11.2022.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case networkError(errorDescription: String)
}

class NetworkManager {
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()

    func obtainHotelDescriptions(completion: @escaping (Result<[HotelDescription], NetworkError>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json") else {
            return
        }

        session.dataTask(with: url) { [weak self] data, _, error in
            let result: Result<[HotelDescription], NetworkError>

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            guard let strongSelf = self else {
                result = .failure(.networkError(errorDescription: "Error create strong ref"))
                return
            }

            guard let data = data, error == nil else {
                result = .failure(.networkError(errorDescription: "Downloading error"))
                return
            }

            guard let hotelDescriptions = try? strongSelf.decoder.decode([HotelDescription].self, from: data) else {
                result = .failure(.networkError(errorDescription: "Error JSON decoding"))
                return
            }

            result = .success(hotelDescriptions)
        }.resume()
    }

    func obtainHotelInfoForDescriptionId(id: String, completion: @escaping (Result<HotelInfo, NetworkError>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/\(id).json") else {
            return
        }

        session.dataTask(with: url) { [weak self] data, _, error in
            let result: Result<HotelInfo, NetworkError>

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            guard let strongSelf = self else {
                result = .failure(.networkError(errorDescription: "Error create strong ref"))
                return
            }

            guard let data = data, error == nil else {
                result = .failure(.networkError(errorDescription: "Downloading error"))
                return
            }

            guard let hotelInfo = try? strongSelf.decoder.decode(HotelInfo.self, from: data) else {
                result = .failure(.networkError(errorDescription: "Error JSON decoding"))
                return
            }

            result = .success(hotelInfo)
        }.resume()
    }

    func obtainHotelImageForImageId(id: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: "https://github.com/iMofas/ios-android-test/raw/master/\(id).jpg") else {
            return
        }

        session.dataTask(with: url) { data, _, error in
            var result: Result<UIImage, NetworkError>

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            guard let data = data, error == nil else {
                result = .failure(.networkError(errorDescription: "Downloading error"))
                return
            }

            guard let image = UIImage(data: data) else {
                result = .failure(.networkError(errorDescription: "Incorrect image data error"))
                return
            }

            result = .success(image)

        }.resume()
    }
}
