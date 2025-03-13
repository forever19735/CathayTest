//
//  CustomTabBarButton.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/25.
//
import UIKit

class CustomTabBarButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        let spacing: CGFloat = 4
        let imageSize = CGSize(width: 24, height: 24)
        let titleSize = titleLabel.intrinsicContentSize

        let totalHeight = imageSize.height + spacing + titleSize.height
        let imageX = (bounds.width - imageSize.width) / 2
        let imageY = (bounds.height - totalHeight) / 2

        imageView.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)

        titleLabel.frame = CGRect(x: 0, y: imageView.frame.maxY + spacing, width: bounds.width, height: titleSize.height)
    }
    
    private func setupButton() {
        titleLabel?.apply(font: UIFont.font(.sfproRegular, fontSize: 12), textColor: UIColor.cubeColorSystemGray7, textAlignment: .center)
        imageView?.contentMode = .scaleAspectFit
    }
}
