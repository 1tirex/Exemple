public extension UIView {
    
    /// add ovarlay with color on any view
    /// - Parameters:
    ///   - color: what color do you want to add on view
    ///   - alpha: and opasity
    func addOverlay(
        color: UIColor = .black,
        alpha : CGFloat = 0.6
    ) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }
    
    /// add gradient on view
    /// - Parameter colors: many colors
    func addGradient(
        colors: [UIColor] = [.clear, .black]
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)
    }
}
