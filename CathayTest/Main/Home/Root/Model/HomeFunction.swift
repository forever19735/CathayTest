//
//  HomeFunction.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/9.
//
import UIKit

extension HomeViewController {
    enum HomeFunction: CaseIterable {
        case transfer
        case payment
        case utility
        case scan
        case qrcode
        case topup

        var title: String {
            switch self {
            case .transfer:
                return "Transfer"
            case .payment:
                return "Payment"
            case .utility:
                return "Utility"
            case .scan:
                return "QR pay scan"
            case .qrcode:
                return "My QR code"
            case .topup:
                return "Top up"
            }
        }

        var icon: ImageAsset {
            switch self {
            case .transfer:
                return .iconMenuTransfer
            case .payment:
                return .iconMenuPayment
            case .utility:
                return .iconMenuUtility
            case .scan:
                return .iconMenuScan
            case .qrcode:
                return .iconMenuQrCode
            case .topup:
                return .iconMenuTopUp
            }
        }
    }
}
