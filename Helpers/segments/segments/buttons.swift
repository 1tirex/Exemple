//
//  buttons.swift
//  segments
//
//  Created by Ilya on 12.02.23.
//

import UIKit

class PushButton: UIButton {
    
    // MARK: - Properties
    private var transformScale: CGFloat = 0.7
    
    // MARK: - Initialization
    convenience init(
        title: String,
        titleColor: UIColor,
        backgroundColor: UIColor,
        font: UIFont?,
        cornerRadius: CGFloat,
        transformScale: CGFloat = 0.7
    ) {
        self.init()
        layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.transformScale = transformScale
        addLabel(text: title, font: font, color: titleColor)
    }
    
    // MARK: - overrides
    override var isHighlighted: Bool {
        willSet {
            animate(with: newValue)
        }
    }
    
    // MARK: - Module function
    private func animate(with value: Bool) {
        var transform = CGAffineTransform.identity
        if value {
            transform = CGAffineTransform(
                scaleX: transformScale,
                y: transformScale
            )
        }
        UIView.animate(withDuration: 0.2) {
            self.transform = transform
        }
    }
    
    private func addLabel(
        text: String?,
        font: UIFont?,
        color: UIColor?,
        alignment: NSTextAlignment = .center
    ) {
        setTitle(text, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = font
        titleLabel?.textAlignment = alignment
    }
}
