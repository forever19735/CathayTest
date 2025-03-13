//
//  DefaultAPIProviderFactory.swift
//  NetworkLayer
//
//  Created by 季紅 on 2023/5/29.
//

import Foundation

class RequestFactory {
    static func createRequest<T: DecodableResponseTargetType>(for target: T) -> URLRequest? {
        guard let url = URL(string: target.baseURL + target.path) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue

        if let headers = target.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if let body = target.task?.bodyData {
            request.httpBody = body
        }

        return request
    }
}
