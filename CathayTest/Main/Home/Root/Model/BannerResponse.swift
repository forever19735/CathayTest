//
//  BannerResponse.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//

// MARK: - BannerResponse
struct BannerResponse: Codable {
    let bannerList: [BannerList]
}

// MARK: - BannerList
struct BannerList: Codable {
    let adSeqNo: Int
    let linkURL: String

    enum CodingKeys: String, CodingKey {
        case adSeqNo
        case linkURL = "linkUrl"
    }
}
