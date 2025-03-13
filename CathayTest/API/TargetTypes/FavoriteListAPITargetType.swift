//
//  FavoriteListAPITargetType.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//

import Foundation

protocol FavoriteListAPITargetType: DecodableResponseTargetType {}

extension FavoriteListAPITargetType {
    var baseURL: String {
        return "https://willywu0201.github.io/data"
    }

    var method: HTTPMethod { .GET }

    var headers: [String: String]? {
        return nil
    }
}

enum FavoriteListAPI {

    struct FavoriteList: FavoriteListAPITargetType {
        typealias Response = FavoriteListResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/favoriteList.json" }
    }

}
