//
//  HomeViewController.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/6.
//

import UIKit

class HomeViewController: BaseViewController, Refreshable, UICollectionViewConfigurable {
    var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!

    typealias Section = HomeSection

    typealias Item = HomeItem

    var collectionView: UICollectionView!

    var refreshAdaptor: RefreshAdaptor?

    private let viewModel: HomeViewModel

    private lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView()
        view.delegate = self
        return view
    }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        initDataSource()
//        viewModel.getTotalBalance(version: .v1)
//        viewModel.getBanner()
        binding()
        viewModel.inputs.viewDidLoad()
        refreshAdaptor = RefreshAdaptor(targetView: collectionView, delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func setupUI() {
        view.addSubviews([headerView])
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: HomeItem) -> UICollectionViewCell? {
        switch item {
        case let .balance(model):
            let cell = collectionView.dequeueReusableCell(withClass: BalanceCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: model)
            return cell
        case let .main(model):
            let cell = collectionView.dequeueReusableCell(withClass: FunctionCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: model)
            return cell
        case let .emptyFavorite(model):
            let cell = collectionView.dequeueReusableCell(withClass: EmptyFavoriteCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: model)
            return cell
        case let .favorite(model):
            let cell = collectionView.dequeueReusableCell(withClass: FavoriteCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: model)
            return cell
        case let .banner(model):
            let cell = collectionView.dequeueReusableCell(withClass: BannerCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: model)
            return cell
        }
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(cellWithClass: BalanceCollectionViewCell.self)
        collectionView.register(cellWithClass: FunctionCollectionViewCell.self)
        collectionView.register(cellWithClass: EmptyFavoriteCollectionViewCell.self)
        collectionView.register(cellWithClass: FavoriteCollectionViewCell.self)
        collectionView.register(cellWithClass: BannerCollectionViewCell.self)

        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: HeaderMoreCollectionReusableView.self)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension HomeViewController {
    func binding() {
        viewModel.outputs.balance
            .dropFirst()
            .sink { [weak self] totalBalance in
                guard let self = self else { return }
                self.configureBalanceItems(totalBalance?.usd, khr: totalBalance?.khr)
            }
            .store(in: &cancellables)

        viewModel.outputs.notifications
            .dropFirst()
            .sink { [weak self] notificationListResponse in
                guard let self = self else { return }
                let bellIsActive = !notificationListResponse.isEmpty
                self.headerView.config(bellIsActive: bellIsActive)
            }
            .store(in: &cancellables)

        viewModel.outputs.favorites
            .dropFirst()
            .sink { [weak self] favoriteListResponse in
                guard let self = self else { return }
                self.configureFavoriteItems(favoriteListResponse)
            }
            .store(in: &cancellables)

        viewModel.outputs.banners
            .dropFirst()
            .sink { [weak self] bannerResponse in
                guard let self = self else { return }
                self.configureBannerItems(bannerResponse)
            }
            .store(in: &cancellables)

        viewModel.outputs.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                self.showAlert(message: error)
            }
            .store(in: &cancellables)
    }
}

private extension HomeViewController {
    func configureBalanceItems(_ usd: Double?, khr: Double?) {
        let balanceData = BalanceCellData(usdAmount: usd, khrAmount: khr)
        updateSingleItem(in: .balance, newData: balanceData) { data in
            Item.balance(data)
        }
    }

    func initDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.balance, .main, .emptyFavorite, .banner])

        for element in HomeFunction.allCases {
            let item = Item.main(FunctionCellData(icon: element.icon, title: element.title))
            snapshot.appendItems([item], toSection: .main)
        }

        let item = Item.emptyFavorite(EmptyFavoriteCellData(icon: UIImage(asset: .iconEmptyFavorite), title: "---", description: "You can add a favorite through the transfer or payment function."))
        snapshot.appendItems([item], toSection: .emptyFavorite)

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func configureFavoriteItems(_ favoriteList: [FavoriteList]) {
        var snapshot = dataSource.snapshot()

        if snapshot.sectionIdentifiers.contains(.emptyFavorite) {
            snapshot.deleteSections([.emptyFavorite])
        }

        if !snapshot.sectionIdentifiers.contains(.favorite) {
            snapshot.insertSections([.favorite], afterSection: .main)
        }

        let newItems: [Item] = favoriteList.compactMap { element in
            guard let transferType = element.favoriteFunction else { return nil }
            return Item.favorite(FavoriteCellData(icon: transferType.icon, title: element.nickname))
        }

        let currentItems = snapshot.itemIdentifiers(inSection: .favorite)

        let itemsToDelete = currentItems.filter { !newItems.contains($0) }

        let itemsToAdd = newItems.filter { !currentItems.contains($0) }

        if !itemsToDelete.isEmpty {
            snapshot.deleteItems(itemsToDelete)
        }

        if !itemsToAdd.isEmpty {
            snapshot.appendItems(itemsToAdd, toSection: .favorite)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func configureBannerItems(_ bannerList: [BannerList]) {
        let imagePaths = bannerList.map { $0.linkURL }
        let bannerData = BannerCellData(imagePaths: imagePaths)
        updateSingleItem(in: .banner, newData: bannerData) { data in
            Item.banner(data)
        }
    }
}

extension HomeViewController {
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: HeaderMoreCollectionReusableView.self, for: indexPath)
        let sections = dataSource.snapshot().sectionIdentifiers
        guard indexPath.section < sections.count else { return header }

        let section = sections[indexPath.section]

        header.configureUI(tag: indexPath.section,
                           title: section.headerTitle,
                           moreTitle: section.moreTitle)
        return header
    }
}

extension HomeViewController {
    enum HomeSection: CaseIterable, SectionLayoutProvider {
        case balance
        case main
        case emptyFavorite
        case favorite
        case banner

        var headerTitle: String {
            switch self {
            case .emptyFavorite,
                 .favorite:
                return "My Favorite"
            default: return ""
            }
        }

        var moreTitle: String? {
            switch self {
            case .emptyFavorite,
                 .favorite:
                return "More"
            default: return nil
            }
        }
        
        private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            header.pinToVisibleBounds = false
            return header
        }

        func createLayout() -> NSCollectionLayoutSection {
            let group = createGroup(for: self)
            let section = NSCollectionLayoutSection(group: group)

            configureSection(section, for: self)

            return section
        }

        private func createGroup(for sectionType: Section) -> NSCollectionLayoutGroup {
            switch sectionType {
            case .balance:
                return createGroup(width: .fractionalWidth(1), height: .estimated(120), itemWidth: .fractionalWidth(1), itemHeight: .estimated(120))

            case .main:
                return createGroup(width: .fractionalWidth(1), height: .estimated(84), itemWidth: .fractionalWidth(1), itemHeight: .fractionalHeight(1), itemCount: 3)

            case .emptyFavorite:
                return createGroup(width: .fractionalWidth(1), height: .estimated(88), itemWidth: .fractionalWidth(1), itemHeight: .estimated(120))

            case .favorite:
                return createGroup(width: .absolute(80), height: .absolute(80), itemWidth: .fractionalWidth(1), itemHeight: .fractionalHeight(1))

            case .banner:
                return createGroup(width: .fractionalWidth(1), height: .estimated(88), itemWidth: .fractionalWidth(1), itemHeight: .estimated(120))
            }
        }

        private func configureSection(_ section: NSCollectionLayoutSection, for sectionType: Section) {
            switch sectionType {
            case .main:
                section.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)

            case .emptyFavorite:
                section.boundarySupplementaryItems = [createHeader()]
                section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)

            case .favorite:
                section.boundarySupplementaryItems = [createHeader()]
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)

            case .banner:
                section.contentInsets = .init(top: 20, leading: 24, bottom: 0, trailing: 24)

            default:
                break
            }
        }

        private func createGroup(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, itemWidth: NSCollectionLayoutDimension, itemHeight: NSCollectionLayoutDimension, itemCount: Int = 1) -> NSCollectionLayoutGroup {
            let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
            return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: itemCount)
        }

    }

    enum HomeItem: Hashable {
        case balance(BalanceCellData)
        case main(FunctionCellData)
        case emptyFavorite(EmptyFavoriteCellData)
        case favorite(FavoriteCellData)
        case banner(BannerCellData)
    }
}

extension HomeViewController: HomeHeaderViewDelegate {
    func homeHeaderViewDidTapNotificationButton() {
        let vc = NotificationListViewController(viewModel: NotificationListViewModel())
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: RefreshAdaptorDelegate {
    func refreshAdaptorWillRefresh() {
//        viewModel.getNotificationList()
//        viewModel.getTotalBalance(version: .v2)
//        viewModel.getFavoriteList()
        viewModel.inputs.refresh()
    }
}
