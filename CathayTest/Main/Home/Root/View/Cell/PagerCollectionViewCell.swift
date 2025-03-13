//
//  PagerCollectionViewCell.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/7.
//

import UIKit

struct PagerViewData: Hashable {
    let id: Int?
    let imagePath: String?
}

class PagerCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = PagerViewData

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: PagerViewData) {
        let urlString = viewData.imagePath ?? ""
        imageView.downloadImage(with: urlString, placeHolder: UIImage(named: "icon_ad_empty"))
    }
}

private extension PagerCollectionViewCell {
    func setupConstraint() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}
