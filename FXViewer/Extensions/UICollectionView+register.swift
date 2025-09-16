//
//  UICollectionView+register.swift
//  FXViewer
//
//  Created by Nik Dub on 9/16/25.
//

import UIKit

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(for type: T.Type) {
        self.register(
            type,
            forCellWithReuseIdentifier: type.identifier
        )
    }
    
    func deque<T: UICollectionViewCell>(
        type: T.Type,
        indexPath: IndexPath
    ) -> T {
        return self.dequeueReusableCell(
            withReuseIdentifier: type.identifier,
            for: indexPath
        ) as! T
    }
    
    func deque<T: UICollectionReusableView>(
        type: T.Type, kind: String,
        indexPath: IndexPath
    ) -> T {
        // swiftlint:disable:next force_cast
        return self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: type.identifier,
            for: indexPath
        ) as! T
    }
}
