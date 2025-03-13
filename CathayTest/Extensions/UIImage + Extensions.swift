//
//  UIImage + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

extension UIImage {
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))

        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return imageColored
    }
}

extension UIImage {
    convenience init?(asset: ImageAsset) {
        self.init(named: asset.rawValue)
    }
}
