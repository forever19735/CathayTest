//
//  UIColor + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UIColor {
    @nonobjc class var gray500: UIColor {
        return UIColor(white: 136.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var whiteThree: UIColor {
        return UIColor(white: 240.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var white: UIColor {
        return UIColor(white: 251.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var whiteFour: UIColor {
        return UIColor(white: 220.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cubeColorSystemGray10: UIColor {
        return UIColor(white: 26.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cubeColorSystemGray8: UIColor {
        return UIColor(white: 68.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cubeColorSystemGray6: UIColor {
        return UIColor(white: 111.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cubeColorSystemGray4: UIColor {
        return UIColor(white: 190.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var battleshipGrey: UIColor {
        return UIColor(red: 115.0 / 255.0, green: 116.0 / 255.0, blue: 126.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var orange01: UIColor {
        return UIColor(red: 1.0, green: 136.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cubeColorSystemGray7: UIColor {
        return UIColor(white: 85.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var whiteTwo: UIColor {
        return UIColor(white: 250.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cubeColorSystemGray5: UIColor {
        return UIColor(white: 136.0 / 255.0, alpha: 1.0)
    }
}
