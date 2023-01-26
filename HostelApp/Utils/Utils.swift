//
//  Utils.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 16.11.2022.
//

import Foundation
import UIKit

extension String {
    func getNumberAvailableRooms() -> Int {
        return self.split(separator: ":").count
    }
}

extension UIImage {
    func croppedImageBorders(pixelsToCrop offset: Double) -> UIImage {
        let cropRect = CGRect(x: offset, y: offset, width: self.size.width - offset - 2 * offset, height: self.size.height - 2 * offset)
        let sourceCGImage = self.cgImage!
        let croppedCGImage = sourceCGImage.cropping(to: cropRect)!
        let croppedImage = UIImage(cgImage: croppedCGImage, scale: self.imageRendererFormat.scale, orientation: self.imageOrientation)
        return croppedImage
    }
}
