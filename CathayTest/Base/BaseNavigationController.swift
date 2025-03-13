//
//  BaseNavigationController.swift
//  Carguru_c2b2c
//
//  Created by 季紅 on 2022/4/18.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
