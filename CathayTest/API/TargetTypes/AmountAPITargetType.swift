//
//  AmountAPITargetType.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//

import Foundation

protocol AmountAPITargetType: DecodableResponseTargetType {}

extension AmountAPITargetType {
    var baseURL: String {
        return "https://willywu0201.github.io/data"
    }

    var method: HTTPMethod { .GET }

    var headers: [String: String]? {
        return nil
    }
}

enum AmountAPI {

    struct USDSavings1: AmountAPITargetType {
        typealias Response = SavingResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/usdSavings1.json" }
    }

    struct USDFixed1: AmountAPITargetType {
        typealias Response = FixedResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/usdFixed1.json" }
    }

    struct USDDigital1: AmountAPITargetType {
        typealias Response = DigitalResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/usdDigital1.json" }
    }

    struct KHRSavings1: AmountAPITargetType {
        typealias Response = SavingResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/khrSavings1.json" }
    }

    struct KHRFixed1: AmountAPITargetType {
        typealias Response = FixedResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/khrFixed1.json" }
    }

    struct KHRDigital1: AmountAPITargetType {
        typealias Response = DigitalResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/khrDigital1.json" }
    }

    struct USDSavings2: AmountAPITargetType {
        typealias Response = SavingResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/usdSavings2.json" }
    }

    struct USDFixed2: AmountAPITargetType {
        typealias Response = FixedResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/usdFixed2.json" }
    }

    struct USDDigital2: AmountAPITargetType {
        typealias Response = DigitalResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/usdDigital2.json" }
    }

    struct KHRSavings2: AmountAPITargetType {
        typealias Response = SavingResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/khrSavings2.json" }
    }

    struct KHRFixed2: AmountAPITargetType {
        typealias Response = FixedResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/khrFixed2.json" }
    }

    struct KHRDigital2: AmountAPITargetType {
        typealias Response = DigitalResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/khrDigital2.json" }
    }
}

