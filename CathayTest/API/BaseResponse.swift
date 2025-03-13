//
//  BaseResponse.swift
//  NetworkLayer
//
//  Created by 季紅 on 2023/1/18.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let msgCode: String?
    let msgContent: String?
    let result: T?
}
