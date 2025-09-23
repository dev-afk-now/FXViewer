//
//  HomeCollectionAdapter.swift
//  FXViewer
//
//  Created by Nik Dub on 05.05.2025.
//

import UIKit

enum HomeSection: Hashable {
    case main
    case skeleton
}

class HomeCollectionAdapter: CollectionAdapter<HomeSection, CurrencyModel> {
    
    private weak var pullDelegate: PullProgressDelegate?
    private var hasUserScrolled = false
    private let cellAction: (String) -> ()
    
    init(
        collectionView: UICollectionView,
        pullDelegate: PullProgressDelegate? = nil,
        _ cellAction: @escaping (String) -> () = {_ in }
    ) {
        self.pullDelegate = pullDelegate
        self.cellAction = cellAction
        super.init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                guard item.isEmpty else {
                    let cell = collectionView.deque(
                        type: CurrencyCell.self,
                        indexPath: indexPath
                    )
                    cell.configure(with: item)
                    return cell
                }
                return collectionView.deque(
                    type: SkeletonCell.self,
                    indexPath: indexPath
                )
            },
            onSelect: nil
        )
    }
}

extension HomeCollectionAdapter: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !hasUserScrolled {
            return
        }
        let offsetY = scrollView.contentOffset.y
        guard offsetY < 0 else { return }
        let progress = min(abs(offsetY) / 100, 1.0)
        pullDelegate?.pullProgressDidChange(progress)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hasUserScrolled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pullDelegate?.scrollDidEnd()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { [unowned self] _ in
            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return UIMenu()
            }
            let favorite = UIAction(
                title: item.isFavorite ? "Remove" : "Add",
                image: UIImage(systemName: item.isFavorite ? "star.fill" : "star")
            ) { [unowned self] _ in
                cellAction(item.code)
            }
            return UIMenu(title: .empty, children: [favorite])
        }
    }
}
