//
//  Utils.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 16.11.2022.
//

import Foundation
import UIKit

func getNumberAvailableRoomsFor(suitesAvailability: String) -> Int {
    return suitesAvailability.split(separator: ":").count
}

func croppedImageBordersFor(image: UIImage, pixelsToCrop offset: Double) -> UIImage {
    let cropRect = CGRect(x: offset, y: offset, width: image.size.width - offset - 2 * offset, height: image.size.height - 2 * offset)
    let sourceCGImage = image.cgImage!
    let croppedCGImage = sourceCGImage.cropping(to: cropRect)!
    let croppedImage = UIImage(cgImage: croppedCGImage, scale: image.imageRendererFormat.scale, orientation: image.imageOrientation)
    return croppedImage
}
