//
//  GradientView.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/19.
//
import UIKit

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor,
            UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1).cgColor,
          
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
}

