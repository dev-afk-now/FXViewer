//
//  FavoritesCollectionAdapter.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

import UIKit

enum FavoritesSection: Hashable {
    case main
    case skeleton
}

class FavoritesCollectionAdapter: CollectionAdapter<FavoritesSection, CurrencyModel> {
    private let cellAction: (String) -> ()
    
    init(
        collectionView: UICollectionView,
        _ cellAction: @escaping (String) -> ()
    ) {
        self.cellAction = cellAction
        super.init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.deque(
                    type: CurrencyCell.self,
                    indexPath: indexPath
                )
                cell.configure(with: item)
                return cell
            },
            onSelect: nil
        )
    }
}

extension FavoritesCollectionAdapter: UICollectionViewDelegate {
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
            return UIMenu(
                title: .empty,
                children: [
                    UIAction(
                        title: "Remove",
                        image: UIImage(systemName: "star.fill")
                    ) { [unowned self] _ in
                        cellAction(item.code)
                    }
                ]
            )
        }
    }
}
