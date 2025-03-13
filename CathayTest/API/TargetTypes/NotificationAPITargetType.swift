//
//  TestAPITargetType.swift
//  NetworkLayer
//
//  Created by 季紅 on 2023/3/20.
//

import Foundation

protocol NotificationAPITargetType: DecodableResponseTargetType {}

extension NotificationAPITargetType {
    var baseURL: String {
        return "https://willywu0201.github.io/data"
    }

    var method: HTTPMethod { .GET }

     var headers: [String: String]? {
        return nil
    }
}

enum NotificationAPI {

    struct NotificationList: NotificationAPITargetType {
        typealias Response = NotificationListResponse

        var task: HTTPTask? { .requestPlain }

        var path: String { "/notificationList.json" }
    }

}
