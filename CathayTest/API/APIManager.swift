//
//  APIManager.swift
//  NetworkLayer
//
//  Created by 季紅 on 2023/3/20.
//

import Foundation

protocol APIManagerProtocol {
    func request<T: DecodableResponseTargetType>(_ targetType: T,
                                                 queue: DispatchQueue,
                                                 completion: @escaping ((Result<T.Response?, APIError>) -> Void))
}

final class APIManager {
    static let shared = APIManager()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
}

extension APIManager: APIManagerProtocol {
    func request<T: DecodableResponseTargetType>(_ targetType: T,
                                                 queue: DispatchQueue = .global(qos: .background),
                                                 completion: @escaping ((Result<T.Response?, APIError>) -> Void)) {
        guard let request = RequestFactory.createRequest(for: targetType) else {
            completion(.failure(.invalidRequest))
            return
        }

        queue.async { [weak self] in
            guard let self = self else { return }

            let task = self.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }

                guard (200 ... 299).contains(httpResponse.statusCode) else {
                    completion(.failure(.serverError(status: httpResponse.statusCode)))
                    return
                }

                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    let decodedResponse = try self.decoder.decode(BaseResponse<T.Response>.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse.result))
                    }
                } catch {
                    completion(.failure(.decodeFailed(error)))
                }
            }
            task.resume()
        }
    }
}
