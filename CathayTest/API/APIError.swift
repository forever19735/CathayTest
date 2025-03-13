//
//  APIError.swift
//  NetworkLayer
//
//  Created by 季紅 on 2023/3/20.
//

import Foundation

enum APIError: Error {
    case invalidRequest
    case networkError(Error)
    case invalidResponse
    case serverError(status: Int)
    case noData
    case decodeFailed(Error)
}
