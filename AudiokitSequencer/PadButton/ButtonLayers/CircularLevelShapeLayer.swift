//
//  CircularLevelShapeLayer.swift
//  Exported from Kite Compositor for Mac 2.0.2
//
//  Created on 04.09.20, 12:51.
//


import UIKit

class CircularLevelShapeLayer: CAShapeLayer, ButtonLayer {

    private var strokeEndAnimation: CABasicAnimation = {
        let animation = CABasicAnimation()
        animation.beginTime = 0.000001
        animation.duration = 0.000001
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.keyPath = "strokeEnd"
        animation.toValue = 0
        return animation
    }()

    override var lineWidth: CGFloat {
        didSet {
            updatePath()
        }
    }
    
    var level: CGFloat = 0 {
        didSet {
            setStrokeEnd(to: level, animated: false)
        }
    }

    func setUp() {
        setupPath()
        setUpEndAnimation()
        level = 0
    }

    func setupPath() {
        strokeColor = UIColor.iconStrokeColor.cgColor
        fillColor = UIColor.clear.cgColor
        lineWidth = 3
        contentsGravity = .center
        allowsEdgeAntialiasing = true
        allowsGroupOpacity = true
        self.transform = CATransform3DRotate(transform, CGFloat.pi / 180 * 90, 0, 0, 1)
    }

    func setUpEndAnimation() {
        let strokeEndAnimation = CABasicAnimation()
        strokeEndAnimation.beginTime = 0.000001
        strokeEndAnimation.duration = 0.000001
        strokeEndAnimation.fillMode = .forwards
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeEndAnimation.keyPath = "strokeEnd"
        strokeEndAnimation.toValue = 0

        self.strokeEndAnimation = strokeEndAnimation
    }

    func update(bounds: CGRect) {
        self.bounds = bounds
        self.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updatePath()
    }

    func updatePath() {
        let bounds = self.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let offset = lineWidth  / 2
        let radius = self.bounds.width / 4 - offset

        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * CGFloat.pi
        let circle = UIBezierPath(arcCenter: center,
                                  radius: radius,
                                  startAngle: startAngle,
                                  endAngle: endAngle,
                                  clockwise: true)

        self.path = circle.cgPath
    }

    func setStrokeEnd(to: CGFloat, animated: Bool) {
        strokeEndAnimation.beginTime = convertTime(CACurrentMediaTime(), from: nil)
        strokeEndAnimation.duration = animated ? 0.3 : 0.0001
        strokeEndAnimation.toValue = min(max(0, to), 1.0)
        add(self.strokeEndAnimation, forKey: "strokeEndAnimation")
    }
}
