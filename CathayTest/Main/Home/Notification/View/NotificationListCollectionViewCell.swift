//
//  NotificationListCollectionViewCell.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/7.
//

import UIKit

struct NotificationListViewData: Hashable {
    let isRead: Bool
    let title: String
    let date: String
    let description: String
}

class NotificationListCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = NotificationListViewData

    private let redDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange01
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproBold, fontSize: 18), textColor: .cubeColorSystemGray10)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproRegular, fontSize: 14), textColor: .cubeColorSystemGray10)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproRegular, fontSize: 16), textColor: .battleshipGrey, numberOfLines: 2)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.redDotView.layer.cornerRadius = self.redDotView.frame.height / 2
            self.redDotView.layer.masksToBounds = true
        }
    }

    func configure(viewData: NotificationListViewData) {
        redDotView.isHidden = viewData.isRead
        titleLabel.text = viewData.title
        dateLabel.text = viewData.date
        descriptionLabel.text = viewData.description
    }
}

private extension NotificationListCollectionViewCell {
    func setupConstraint() {
        contentView.addSubviews([redDotView, titleLabel, dateLabel, descriptionLabel])
        redDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            redDotView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            redDotView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            redDotView.widthAnchor.constraint(equalToConstant: 12),
            redDotView.heightAnchor.constraint(equalToConstant: 12)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: redDotView.rightAnchor, constant: 4),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
