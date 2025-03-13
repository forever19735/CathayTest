//
//  FavoriteListResponse.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//
import Foundation
// MARK: - FavoriteListResponse
struct FavoriteListResponse: Codable {
    let favoriteList: [FavoriteList]
}

// MARK: - FavoriteList
struct FavoriteList: Codable {
    let nickname, transType: String

    var favoriteFunction: HomeViewController.FavoriteFunction? {
        return HomeViewController.FavoriteFunction(rawValue: transType)
    }
}
