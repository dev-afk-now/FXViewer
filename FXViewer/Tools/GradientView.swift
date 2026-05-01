//
//  GradientView.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//

import UIKit

extension UIView {
    func applyBottomGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.016).cgColor,
            UIColor.black.withAlphaComponent(0.03125).cgColor,
            UIColor.black.withAlphaComponent(0.0625).cgColor,
            UIColor.black.withAlphaComponent(0.125).cgColor,
            UIColor.black.withAlphaComponent(0.25).cgColor,
            UIColor.black.withAlphaComponent(0.45).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradient.frame = CGRect(
            x: 0,
            y: bounds.height - 75,
            width: bounds.width,
            height: 75
        )
        
        layer.addSublayer(gradient)
    }
}
