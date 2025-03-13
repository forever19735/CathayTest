//
//  NotificationListViewModel.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//
import Combine
import Foundation

class NotificationListViewModel {
    @Published var notificationListResponse: [Message] = []
    
    private(set) var errorMessage = PassthroughSubject<String?, Never>()
}

extension NotificationListViewModel {
    func getNotificationList() {
        let targetType = NotificationAPI.NotificationList()
        APIManager.shared.request(targetType) { result in
            switch result {
            case .success(let response):
                self.notificationListResponse = response?.messages ?? []
            case .failure(let failure):
                self.errorMessage.send(failure.localizedDescription)
            }
        }
    }
}
