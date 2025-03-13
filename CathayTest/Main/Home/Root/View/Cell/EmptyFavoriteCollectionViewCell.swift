//
//  EmptyFavoriteCollectionViewCell.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/10.
//

import UIKit

struct EmptyFavoriteCellData: Hashable {
    var icon: UIImage?
    var title: String
    var description: String
}

class EmptyFavoriteCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = EmptyFavoriteCellData

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

    private let descriptionlabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproRegular, fontSize: 14), textColor: .cubeColorSystemGray6, numberOfLines: 0)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: EmptyFavoriteCellData) {
        iconImageView.image = viewData.icon
        titleLabel.text = viewData.title
        descriptionlabel.text = viewData.description
    }
}

extension EmptyFavoriteCollectionViewCell {
    func setupConstraint() {
        contentView.addSubviews([iconImageView, titleLabel, descriptionlabel])
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 56),
            iconImageView.widthAnchor.constraint(equalToConstant: 56)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        descriptionlabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionlabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12),
            descriptionlabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}
