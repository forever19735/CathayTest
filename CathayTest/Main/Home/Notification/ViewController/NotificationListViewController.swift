//
//  NotificationListViewController.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/7.
//

import UIKit

class NotificationListViewController: BaseViewController, Refreshable, UICollectionViewConfigurable {
    typealias Section = NotificationListSection
    
    typealias Item = NotificationListItem
    
    var dataSource: UICollectionViewDiffableDataSource<NotificationListSection, NotificationListItem>!
    
    var collectionView: UICollectionView!
    
    var refreshAdaptor: RefreshAdaptor?
    
    private let viewModel: NotificationListViewModel
    
    init(viewModel: NotificationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        configNavigationBar()
        binding()
        refreshAdaptor = RefreshAdaptor(targetView: collectionView, delegate: self)
        refreshAdaptor?.refresh()
    }
    
    override func setupUI() {
        
    }
    
    func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: NotificationListItem) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withClass: NotificationListCollectionViewCell.self, for: indexPath)
        if case let .main(model) = item {
            cell.configure(viewData: model)
        }
        return cell
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(cellWithClass: NotificationListCollectionViewCell.self)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

private extension NotificationListViewController {
    func configNavigationBar() {
        configureNavigationTitle("Notification")
        configureBackButton()
    }
    
    func binding() {
        viewModel.$notificationListResponse
            .dropFirst()
            .sink { [weak self] notificationListResponse in
                guard let self = self else { return }
                self.loadData(messages: notificationListResponse)
            }
            .store(in: &cancellables)
        
        viewModel.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                self.showAlert(message: error)
            }
            .store(in: &cancellables)
    }
}

private extension NotificationListViewController {
    func loadData(messages: [Message]) {
        let items = messages.map({
            NotificationListItem.main(
                NotificationListViewData(isRead: $0.status,
                                         title: $0.title,
                                         date: $0.updateDateTime,
                                         description: $0.message)
            )
        })
        applySnapshot(sections: [.main], items: [.main: items])
    }
}

extension NotificationListViewController {
    enum NotificationListSection: CaseIterable, SectionLayoutProvider {
        case main
        
        func createLayout() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
    }
    
    enum NotificationListItem: Hashable {
        case main(NotificationListViewData)
    }
}

extension NotificationListViewController: RefreshAdaptorDelegate {
    func refreshAdaptorWillRefresh() {
        viewModel.getNotificationList()
    }
}
