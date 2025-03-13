//
//  Collection + Extensions.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/20.
//
import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
