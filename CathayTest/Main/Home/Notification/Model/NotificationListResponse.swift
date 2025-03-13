//
//  NotificationListResponse.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//

// MARK: - NotificationListResponse
struct NotificationListResponse: Codable {
    let messages: [Message]
}

// MARK: - Message
struct Message: Codable {
    let status: Bool
    let updateDateTime: String
    let title: String
    let message: String
}
