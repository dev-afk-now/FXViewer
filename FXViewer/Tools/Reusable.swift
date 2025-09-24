//
//  Reusable.swift
//  FXViewer
//
//  Created by Nik Dub on 9/16/25.
//

import UIKit

protocol Reusable {}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionReusableView: Reusable {}
extension UIViewController: Reusable {}
