//
//  UICollectionViewConfigurable.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/20.
//
import UIKit

protocol SectionLayoutProvider: Hashable {
    func createLayout() -> NSCollectionLayoutSection
}

protocol CollectionViewLayoutConfigurable: AnyObject, CollectionViewDataSourceConfigurable {
    func createLayout() -> UICollectionViewLayout
    func configureCollectionView()
}

extension CollectionViewLayoutConfigurable where Self: UIViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            guard let self = self,
                  let section = self.dataSource.snapshot().sectionIdentifiers[safe: sectionIndex]
            else {
                return self?.defaultSectionLayout()
            }
            return section.createLayout()
        })
    }

    private func defaultSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )
        return NSCollectionLayoutSection(group: group)
    }
}

protocol CollectionViewDataSourceConfigurable: AnyObject {
    associatedtype Section: SectionLayoutProvider
    associatedtype Item: Hashable

    var collectionView: UICollectionView! { get set }
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! { get set }

    func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell?
    func configureDataSource()
    func applySnapshot(sections: [Section], items: [Section: [Item]], animating: Bool)
}

extension CollectionViewDataSourceConfigurable where Self: UIViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            [weak self] collectionView, indexPath, item in
            return self?.cellProvider(collectionView: collectionView, indexPath: indexPath, item: item)
        }
    }

    func applySnapshot(sections: [Section], items: [Section: [Item]], animating: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(items[section] ?? [], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    // 刪除特定項目
    func deleteItems(_ items: [Item], animating: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(items)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    // 刪除特定 section
    func deleteSections(_ sections: [Section], animating: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteSections(sections)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    // 刪除所有資料
    func deleteAllData(animating: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    // 刪除指定 section 中的特定項目
    func deleteItems(_ items: [Item], fromSection section: Section, animating: Bool = true) {
        var snapshot = dataSource.snapshot()
        let sectionItems = snapshot.itemIdentifiers(inSection: section)
        let itemsToDelete = sectionItems.filter { items.contains($0) }
        snapshot.deleteItems(itemsToDelete)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    // 更新 section 中單個項目的通用方法
    func updateSingleItem<T>(
        in section: Section,
        newData: T?,
        transform: (T) -> Item,
        animating: Bool = false
    ) {
        var snapshot = dataSource.snapshot()

        // 確保 section 存在
        if !snapshot.sectionIdentifiers.contains(section) {
            snapshot.appendSections([section])
        }

        // 取得當前項目
        let currentItems = snapshot.itemIdentifiers(inSection: section)

        if let newData = newData {
            let newItem = transform(newData)

            // 如果有現有項目，先刪除
            if let existingItem = currentItems.first {
                snapshot.deleteItems([existingItem])
            }

            // 添加新項目
            snapshot.appendItems([newItem], toSection: section)
        }

        dataSource.apply(snapshot, animatingDifferences: animating)
    }
}

// 组合使用的 protocol
protocol UICollectionViewConfigurable: CollectionViewLayoutConfigurable & CollectionViewDataSourceConfigurable {}
