//
//  UIViewController + Extensions.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/7.
//
import UIKit

extension UIViewController {

    func configureNavigationTitle(_ title: String?, textColor: UIColor = .cubeColorSystemGray10, backgroundColor: UIColor = .white) {
        navigationItem.title = title
        navigationController?.navigationBar.prefersLargeTitles = false

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.font(.sfproMedium, fontSize: 18),
            .foregroundColor: textColor
        ]

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = attributes
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func configureBackButton(image: UIImage? = UIImage(asset: .iconArrowBack), color: UIColor = .white) {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        backButton.setImage(image, for: .normal)
        backButton.tintColor = color
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc private func handleBackButtonTap() {
        navigateBack()
    }

    func navigateBack(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.setNavigationBarHidden(false, animated: false)
            navigationController.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }

    func showAlert(title: String = "錯誤", message: String?, confirmTitle: String = "確認") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: nil))
        present(alert, animated: true)
    }
}
