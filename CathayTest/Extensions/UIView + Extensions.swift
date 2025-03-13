//
//  UIView + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
    var safeArea: UILayoutGuide {
        return safeAreaLayoutGuide
    }
}
