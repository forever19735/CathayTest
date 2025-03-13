//
//  BalanceCollectionViewCell.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/9.
//

import UIKit

struct BalanceCellData: Hashable {
    let usdAmount: Double?
    let khrAmount: Double?
}

class BalanceCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = BalanceCellData

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproBold, fontSize: 18), textColor: .cubeColorSystemGray5)
        label.text = "My Account Balance"
        return label
    }()

    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(asset: .iconEyeOn), for: .normal)
        button.setImage(UIImage(asset: .iconEyeOff), for: .selected)
        button.addTarget(self, action: #selector(eyeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private let usdCurrencyAmountView: CurrencyAmountView = {
        let view = CurrencyAmountView()
        return view
    }()

    private let khrCurrencyAmountView: CurrencyAmountView = {
        let view = CurrencyAmountView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: BalanceCellData) {
        usdCurrencyAmountView.configure(viewData: CurrencyAmountViewData(currency: "USD", amount: viewData.usdAmount))
        khrCurrencyAmountView.configure(viewData: CurrencyAmountViewData(currency: "KHR", amount: viewData.khrAmount))
    }
}

private extension BalanceCollectionViewCell {
    func setupConstraint() {
        contentView.addSubviews([balanceLabel, eyeButton, verticalStackView])
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            balanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])

        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eyeButton.leftAnchor.constraint(equalTo: balanceLabel.rightAnchor, constant: 8),
            eyeButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor)
        ])

        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 12),
            verticalStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            verticalStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        verticalStackView.addArrangeSubviews([usdCurrencyAmountView, khrCurrencyAmountView])

    }
}

extension BalanceCollectionViewCell {
    @objc func eyeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        usdCurrencyAmountView.setupSecurityStyle(isSecure: sender.isSelected)
        khrCurrencyAmountView.setupSecurityStyle(isSecure: sender.isSelected)
    }
}
