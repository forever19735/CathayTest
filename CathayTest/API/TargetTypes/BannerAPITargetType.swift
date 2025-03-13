//
//  BannerAPITargetType.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//

protocol BannerAPITargetType: DecodableResponseTargetType {}

extension BannerAPITargetType {
    var baseURL: String {
        return "https://willywu0201.github.io/data"
    }

    var method: HTTPMethod { .GET }

    var headers: [String: String]? {
        return nil
    }
}

enum BannerAPI {

    struct Banner: BannerAPITargetType {
        typealias Response = BannerResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/banner.json" }
    }

}
