//
//  FunctionCollectionViewCell.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/6.
//

import UIKit

struct FunctionCellData: Hashable {
    let icon: ImageAsset
    let title: String
}

class FunctionCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = FunctionCellData

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproRegular, fontSize: 14), textColor: .cubeColorSystemGray7, textAlignment: .center)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: FunctionCellData) {
        iconImageView.image = UIImage(asset: viewData.icon)
        titleLabel.text = viewData.title
    }
}

private extension FunctionCollectionViewCell {
    func setupConstraint() {
        contentView.addSubviews([iconImageView, titleLabel])
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
