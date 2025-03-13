//
//  FavoriteCollectionViewCell.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/7.
//

import UIKit

struct FavoriteCellData: Hashable {
    let icon: ImageAsset
    let title: String
}

class FavoriteCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = FavoriteCellData

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproRegular, fontSize: 12), textColor: .cubeColorSystemGray6, textAlignment: .center)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: FavoriteCellData) {
        iconImageView.image = UIImage(asset: viewData.icon)
        titleLabel.text = viewData.title
    }
}

private extension FavoriteCollectionViewCell {
    func setupConstraint() {
        contentView.addSubviews([iconImageView, titleLabel])
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
