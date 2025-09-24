//
//  CollectionAdapter.swift
//  FXViewer
//
//  Created by Nik Dub on 9/18/25.
//

import UIKit

class CollectionAdapter<Section: Hashable, Item: Hashable>: NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    typealias SelectionHandler = (Item) -> Void
    
    private let collectionView: UICollectionView
    private(set) var dataSource: DataSource
    
    init(
        collectionView: UICollectionView,
        cellProvider: @escaping CellProvider,
        onSelect: SelectionHandler? = nil
    ) {
        self.collectionView = collectionView
        self.dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: cellProvider
        )
        super.init()
    }
    
    func applySnapshot(
        sections: [Section],
        itemsBySection: [Section: [Item]],
        animatingDifferences: Bool = true
    ) {
        var snapshot = Snapshot()
        for section in sections {
            snapshot.appendSections([section])
            if let items = itemsBySection[section] {
                snapshot.appendItems(items, toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
