//
//  Endpoint.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//
import Foundation

protocol DecodableResponseTargetType {
    associatedtype Response: Decodable

    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var task: HTTPTask? { get }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum HTTPTask {
    case requestPlain
    case requestData(Data)

    var bodyData: Data? {
        switch self {
        case .requestPlain:
            return nil
        case .requestData(let data):
            return data
        }
    }
}

