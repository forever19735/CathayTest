//
//  UILabel + Extensions.swift
//  HahowTest
//
//  Created by 季紅 on 2024/7/22.
//

import UIKit

extension UILabel {
    func apply(font: UIFont,
               textColor: UIColor,
               textAlignment: NSTextAlignment = .left,
               numberOfLines: Int = 1,
               lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
    }

    func setText(_ text: String, kern: CGFloat = 0, lineSpacing: CGFloat = 0, alignment: NSTextAlignment = .left) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment

        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .kern: kern,
                .paragraphStyle: paragraphStyle
            ]
        )

        attributedText = attributedString
    }

}
