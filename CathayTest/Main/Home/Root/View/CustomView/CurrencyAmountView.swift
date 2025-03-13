//
//  CurrencyAmountView.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/6.
//

import UIKit

struct CurrencyAmountViewData {
    let currency: String
    let amount: Double?
}

class CurrencyAmountView: UIView, ConfigUI {
    typealias ViewData = CurrencyAmountViewData

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.sfproRegular, fontSize: 16), textColor: .cubeColorSystemGray7)
        return label
    }()

    private let amoutTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.font(.sfproMedium, fontSize: 24)
        textField.textColor = .cubeColorSystemGray8
        textField.isEnabled = false
        return textField
    }()
    
    private let gradientView: GradientView  = {
        let view = GradientView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var originalText: String = ""

    init() {
        super.init(frame: .zero)
        setupConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: CurrencyAmountViewData) {
        currencyLabel.text = viewData.currency
        let amount = viewData.amount
        amoutTextField.text = amount?.formattedWithSeparator()
        originalText = amoutTextField.text ?? ""
        gradientView.isHidden = amount != nil
    }

    func setupSecurityStyle(isSecure: Bool) {
        if isSecure {
            amoutTextField.text = String(repeating: "*", count: originalText.count)
        } else {
            amoutTextField.text = originalText
        }
    }
}

private extension CurrencyAmountView {
    func setupConstraint() {
        addSubviews([currencyLabel, amoutTextField, gradientView])
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        amoutTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currencyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            currencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            currencyLabel.heightAnchor.constraint(equalToConstant: 24),

            amoutTextField.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor),
            amoutTextField.leadingAnchor.constraint(equalTo: currencyLabel.leadingAnchor),
            amoutTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            gradientView.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: currencyLabel.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
}
