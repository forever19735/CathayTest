//
//  HeaderMoreCollectionReusableView.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/6.
//

import UIKit

protocol HeaderMoreViewDelegate: AnyObject {
    func headerMoreButtonDidTapped(tag: Int)
}

class HeaderMoreCollectionReusableView: UICollectionReusableView {

    weak var delegate: HeaderMoreViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproBold, fontSize: 18), textColor: .cubeColorSystemGray5)
        return label
    }()

    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .iconArrowRight), for: .normal)
        button.titleLabel?.font = UIFont.font(.sfproRegular, fontSize: 16)
        button.setTitleColor(.cubeColorSystemGray7, for: .normal)
        button.addTarget(self, action: #selector(moreButtonDidTapped(_:)), for: .touchUpInside)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI(tag: Int,
                     title: String?,
                     moreTitle: String?) {
        titleLabel.text = title
        moreButton.tag = tag
        moreButton.setTitle(moreTitle ?? "", for: .normal)
        moreButton.isHidden = moreTitle == nil ? true : false
    }
}

private extension HeaderMoreCollectionReusableView {
    func setupConstraint() {
        addSubviews([titleLabel, moreButton])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])

        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreButton.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}

private extension HeaderMoreCollectionReusableView {
    @objc func moreButtonDidTapped(_ sender: UIButton) {
        delegate?.headerMoreButtonDidTapped(tag: sender.tag)
    }
}

