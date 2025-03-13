//
//  UIFont + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

extension UIFont {

    enum FontType {
        case sfproRegular
        case sfproMedium
        case sfproBold
    }

    static func font(_ fontType: FontType, fontSize size: CGFloat) -> UIFont {
        switch fontType {
        case .sfproRegular:
            return UIFont.systemFont(ofSize: size, weight: .regular)
        case .sfproMedium:
            return UIFont.systemFont(ofSize: size, weight: .medium)
        case .sfproBold:
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
}

