//
//  CustomTabBarController.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/24.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    private let customTabBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private var tabButtons: [CustomTabBarButton] = []
    private let tabItems: [(title: String, icon: ImageAsset)] = [
        ("Home", .iconTabbarHome),
        ("Account", .iconTabbarAccount),
        ("Location", .iconTabbarLocation),
        ("Service", .iconTabbarLocation)
    ]
    
    override var selectedIndex: Int {
        didSet {
            updateTabSelection()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCustomTabBar()
        updateTabSelection()
    }
    
    private func setupViewControllers() {
        let homeVC = BaseNavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel()))
        let accountVC = UIViewController()
        let locationVC = UIViewController()
        let serviceVC = UIViewController()
        
        viewControllers = [homeVC, accountVC, locationVC, serviceVC]
    }
    
    private func setupCustomTabBar() {
        tabBar.isHidden = true
        
        view.addSubview(customTabBarView)
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            customTabBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        for (index, item) in tabItems.enumerated() {
            let button = createTabButton(index: index, title: item.title, icon: item.icon)
            tabButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        customTabBarView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: customTabBarView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: customTabBarView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: customTabBarView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: customTabBarView.bottomAnchor, constant: -5)
        ])
    }
    
    private func createTabButton(index: Int, title: String, icon: ImageAsset) -> CustomTabBarButton {
        let button = CustomTabBarButton()
        button.tag = index
        button.setTitle(title, for: .normal)
        
        let image = UIImage(asset: icon)
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        self.selectedViewController = viewControllers?[selectedIndex]
    }
    
    private func updateTabSelection() {
        for (index, button) in tabButtons.enumerated() {
            let isSelected = index == selectedIndex
            let selectedColor: UIColor = .orange01
            let normalColor: UIColor = .cubeColorSystemGray7
            
            button.tintColor = isSelected ? selectedColor : normalColor
            button.setTitleColor(isSelected ? selectedColor : normalColor, for: .normal)
//            if let image = button.image(for: .normal) {
//                button.setImage(image.tint(with: isSelected ? selectedColor : normalColor), for: .normal)
//                   }
        }
    }
}


