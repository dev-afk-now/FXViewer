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
    init(
        collectionView: UICollectionView,
        _ cellAction: @escaping (String) -> ()
    ) {
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
