//
//  UIColor+AppColor.swift
//  FXViewer
//
//  Created by Nik Dub on 9/16/25.
//

import UIKit

enum AppColor: String {
    case background = "background"
    case containerDark
    case subtitleDark
    case titleLight
    case navigationDark
}

extension UIColor {
    static func appColor(_ color: AppColor) -> UIColor {
        return UIColor(named: color.rawValue) ?? .black
    }
}
