//
//  UIImage+AppImage.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

import UIKit

enum AppImage: String {
    case logo = "fxviewerlogo"
    case placeholder = "placeholder"
}

extension UIImage {
    static func appImage(_ appImage: AppImage) -> UIImage {
        return UIImage(named: appImage.rawValue) ?? UIImage()
    }
}
