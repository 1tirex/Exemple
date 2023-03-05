public final class MyActivityIndicator: UIImageView {
    public override func startAnimating() {
        isHidden = false
        rotate()
    }

    public override func stopAnimating() {
        isHidden = true
        removeRotation()
    }

    private func rotate() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }

    private func removeRotation() {
        layer.removeAnimation(forKey: "rotationAnimation")
    }
}

//Use like:
private let activityIndicator: UIImageView = {
    let spinner = MyActivityIndicator()
    spinner.image = YourImage
    return spinner
}()

activityIndicator.startAnimating()
activityIndicator.stopAnimating()

//Don't forget addSubviews where you want to show
