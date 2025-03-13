//
//  RefreshAdaptor.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/9.
//

import UIKit

protocol RefreshAdaptorDelegate: AnyObject {
    func refreshAdaptorWillRefresh()
}

class RefreshAdaptor: NSObject {
    weak var delegate: RefreshAdaptorDelegate?

    private var refreshControl = UIRefreshControl()
    private weak var targetView: UIScrollView?

    init(targetView: UIScrollView, delegate: RefreshAdaptorDelegate?) {
        self.targetView = targetView
        self.delegate = delegate
        super.init()
        setupRefresh()
    }

}

extension RefreshAdaptor {
    private func setupRefresh() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        if let tableView = targetView as? UITableView {
            tableView.refreshControl = refreshControl
        } else if let collectionView = targetView as? UICollectionView {
            collectionView.refreshControl = refreshControl
        }
    }

    @objc func refresh() {
        delegate?.refreshAdaptorWillRefresh()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
}
