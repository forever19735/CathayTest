//
//  BannerCollectionViewCell.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/7.
//

import UIKit

struct BannerCellData: Hashable {
    let imagePaths: [String]
}

class BannerCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = BannerCellData

    private let pagerView: PagerView = {
        let view = PagerView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: BannerCellData) {
        pagerView.configureDataSource(imagePaths: viewData.imagePaths)
    }
}

private extension BannerCollectionViewCell {
    func setupConstraint() {
        contentView.addSubview(pagerView)
        pagerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pagerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pagerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            pagerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            pagerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
