//
//  UIStackView + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

extension UIStackView {
    func addArrangeSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }

    func removeArrangeSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
