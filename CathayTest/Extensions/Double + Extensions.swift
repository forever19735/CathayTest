//
//  Double + Extensions.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/10.
//
import Foundation

extension Double {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
