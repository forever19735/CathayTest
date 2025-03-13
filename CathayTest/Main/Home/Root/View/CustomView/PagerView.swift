//
//  PagerView.swift
//  Carguru_c2b2c
//
//  Created by 季紅 on 2022/4/12.
//

import UIKit

class PagerView: UIView {
    private lazy var dataSource = makeDataSource()

    private var snapshot = NSDiffableDataSourceSnapshot<Section, PagerViewData>()

    private var timer: Timer?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.alwaysBounceVertical = false
        collectionView.register(cellWithClass: PagerCollectionViewCell.self)
        return collectionView
    }()

    private var layoutSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, _, _ in
            guard let self = self else { return }
            let page = visibleItems.last?.indexPath.item ?? 0
            self.pageControl.currentPage = page
        }
        return section
    }

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        return layout
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.isEnabled = false
        return pageControl
    }()

    init() {
        super.init(frame: .zero)
        setupConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PagerView {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, PagerViewData> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withClass: PagerCollectionViewCell.self, for: indexPath)
            cell.configure(viewData: item)
            return cell
        }
    }

    func configureDataSource(imagePaths: [String]) {
        resetData()
        snapshot = NSDiffableDataSourceSnapshot<Section, PagerViewData>()
        snapshot.appendSections(Section.allCases)
        if imagePaths.isEmpty {
            let item = PagerViewData(id: nil, imagePath: nil)
            snapshot.appendItems([item])
        } else {
            for value in imagePaths.enumerated() {
                let item = PagerViewData(id: value.offset, imagePath: value.element)
                snapshot.appendItems([item])
            }
        }
       
        pageControl.numberOfPages = imagePaths.count

        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
            self.startAutoScroll()
        }
    }
}

extension PagerView {
    private enum Section: CaseIterable {
        case main
    }
}

private extension PagerView {
    func setupConstraint() {
        addSubviews([collectionView, pageControl])
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 8)
        ])
    }

    func startAutoScroll() {
        stopAutoScroll()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            self?.scrollToNextItem()
        }
    }

    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    func scrollToNextItem() {
        guard pageControl.numberOfPages > 1 else { return }
        let nextPage = (pageControl.currentPage + 1) % pageControl.numberOfPages
        let nextIndexPath = IndexPath(item: nextPage, section: 0)

        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = nextPage
    }

    func resetData() {
        stopAutoScroll()
        pageControl.currentPage = 0
        snapshot.deleteSections(Section.allCases)
        dataSource.apply(snapshot)
    }
}
