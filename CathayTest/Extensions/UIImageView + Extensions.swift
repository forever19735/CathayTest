//
//  UIImageView + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

extension UIImageView {
    func downloadImage(with urlString: String, placeHolder: UIImage? = nil) {
        image = placeHolder

        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let image = try await fetchImage(from: url)
                DispatchQueue.main.async {
                    self.image = image
                }
            } catch {
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
            }
        }
    }

    private func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }

        return image
    }
}
