import UIKit

class MovaLoaderView: UIView {
    
    private let dotColor = UIColor.systemRed
    private let dotCount = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDots()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDots()
    }
    
    private func setupDots() {
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius: CGFloat = 20
        
        for i in 0..<dotCount {
            let angle = CGFloat(Double(i) * (2.0 * .pi / Double(dotCount)))
            
            let x = centerPoint.x + radius * cos(angle)
            let y = centerPoint.y + radius * sin(angle)

            let dotSize: CGFloat = CGFloat(2 + i)
            let dot = UIView(frame: CGRect(x: 0, y: 0, width: dotSize, height: dotSize))
            dot.center = CGPoint(x: x, y: y)
            dot.backgroundColor = dotColor
            dot.layer.cornerRadius = dotSize / 2
            
            addSubview(dot)
        }
    }
    
    func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.2
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopAnimating() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
