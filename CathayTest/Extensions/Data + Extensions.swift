//
//  Data + Extensions.swift
//  NetworkLayer
//
//  Created by 季紅 on 2023/3/20.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            return String(data: data, encoding: .utf8)
        } catch {
            print("Error parsing JSON data: \(error)")
            return nil
        }
    }
}
