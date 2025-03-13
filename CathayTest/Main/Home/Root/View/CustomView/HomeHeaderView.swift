//
//  HomeHeaderView.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/6.
//

import UIKit

protocol HomeHeaderViewDelegate: AnyObject {
    func homeHeaderViewDidTapNotificationButton()
}

class HomeHeaderView: UIView {
    weak var delegate: HomeHeaderViewDelegate?

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: .iconAvatar)
        return imageView
    }()

    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .iconBellNormal), for: .normal)
        button.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)
        setupConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(bellIsActive: Bool) {
        let image = bellIsActive ? UIImage(asset: .iconBellActive) : UIImage(asset: .iconBellNormal)
        notificationButton.setImage(image, for: .normal)
    }
}

private extension HomeHeaderView {
    func setupConstraint() {
        addSubviews([avatarImageView, notificationButton])
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        notificationButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            notificationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            notificationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            notificationButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
        ])
    }
}

private extension HomeHeaderView {
    @objc func didTapNotificationButton() {
        delegate?.homeHeaderViewDidTapNotificationButton()
    }
}
