//
//  SavingResponse.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//
import Foundation

protocol BalanceResponse {
    var balanceList: [AmountList] { get }
}

struct SavingResponse: Codable, BalanceResponse {
    let savingsList: [AmountList]?
    var balanceList: [AmountList] { savingsList ?? [] }
}

struct FixedResponse: Codable, BalanceResponse {
    let fixedDepositList: [AmountList]?
    var balanceList: [AmountList] { fixedDepositList ?? [] }
}

struct DigitalResponse: Codable, BalanceResponse {
    let digitalList: [AmountList]?
    var balanceList: [AmountList] { digitalList ?? [] }
}

// MARK: - AmountList
struct AmountList: Codable {
    let account, curr: String
    let balance: Double
}
