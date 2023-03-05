extension UIButton {
    
    ----====----
    
    /// Tap animation
    func makeSystem() {
        addTarget(self, action: #selector(handleIn), for: [
            .touchDown,
            .touchDragInside
        ])
        
        addTarget(self, action: #selector(handleOut), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchUpOutside,
            .touchDragExit,
            .touchCancel
        ])
    }
    
    /// Animation pressed
    @objc func handleIn() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.alpha = 0.55
            animate(with: true)
        }
    }
    
    /// Animation out
    @objc func handleOut() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.alpha = 1
            animate(with: false)
        }
    }
    
    /// How to animate click
    /// - Parameter value: increase(true) or decrease(false)
    private func animate(with value: Bool) {
        let transformScale = 0.9
        var transform = CGAffineTransform.identity
        
        if value {
            transform = CGAffineTransform(
                scaleX: transformScale,
                y: transformScale
            )
        }
        self.transform = transform
    }
    
    ----====----

    /// Set custom title
    /// - Parameters:
    ///   - text: text =)
    ///   - font: your font
    ///   - color: color text
    ///   - alignment: alignment description
    func addTitle(
        text: String? = nil,
        font: UIFont?,
        color: UIColor = Resouces.Colors.text,
        alignment: NSTextAlignment = .center
    ) {
        setTitle(text, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = font
        titleLabel?.textAlignment = alignment
    }
    
    ----====----
    
}
