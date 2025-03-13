//
//  FavoriteFunction.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/9.
//
import UIKit

extension HomeViewController {
    enum FavoriteFunction: String, CaseIterable {
        case cubc = "CUBC"
        case mobile = "Mobile"
        case pmf = "PMF"
        case creditCard = "CreditCard"

        var icon: ImageAsset {
            switch self {
            case .cubc:
                return .iconFavoriteTree
            case .mobile:
                return .iconFavoriteMobile
            case .pmf:
                return .iconFavoriteBuilding
            case .creditCard:
                return .iconFavoriteCreditCard
            }
        }
    }
}
