//
//  Int + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import Foundation

extension Int {
    func formattedWithThousandSeparator() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
