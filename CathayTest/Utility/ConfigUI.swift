//
//  ConfigUI.swift
//  HahowTest
//
//  Created by 季紅 on 2024/6/26.
//

import Foundation

protocol ConfigUI {
    associatedtype ViewData
    func configure(viewData: ViewData)
}

extension ConfigUI {
    func configure(viewData: ViewData) {}
}
