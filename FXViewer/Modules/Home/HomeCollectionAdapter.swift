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
    
    init(
        collectionView: UICollectionView
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
