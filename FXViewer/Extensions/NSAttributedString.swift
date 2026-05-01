//
//  NSAttributedString.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

import UIKit

// TODO: - Replace with AttributedString Builder -

func makeImagedText(
    imageName: String,
    _ text: String,
    color: UIColor = .systemYellow,
    size: CGFloat = 10,
    font: UIFont = .systemFont(ofSize: 16)
) -> NSAttributedString {
    let config = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
    let image = UIImage(
        systemName: imageName,
        withConfiguration: config
    )?
        .withTintColor(color, renderingMode: .alwaysOriginal)
    
    let attachment = NSTextAttachment()
    attachment.image = image
    attachment.bounds = CGRect(
        x: .zero,
        y: (font.capHeight - size) / 2,
        width: size,
        height: size
    )
    let result = NSMutableAttributedString(attachment: attachment)
    result.append(
        NSAttributedString(
            string: " " + text,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.label
            ]
        )
    )
    return result
}
