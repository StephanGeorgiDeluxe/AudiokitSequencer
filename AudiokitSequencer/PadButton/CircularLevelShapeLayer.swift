//
//  CircularLevelShapeLayer.swift
//  Exported from Kite Compositor for Mac 2.0.2
//
//  Created on 04.09.20, 12:51.
//


import UIKit

class CircularLevelShapeLayer: CALayer
{
    // MARK: - Properties

    let shapeLayer = CAShapeLayer()
    private let shapePath = CGMutablePath()
    
    var level: CGFloat = 0 {
        didSet {
            setStrokeEnd(to: level, animated: false)
        }
    }

    private var strokeEndAnimation: CABasicAnimation?

    // MARK: - Setup Layers

    override init() {
        super.init()
        setupLayers()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    func setupLayers()
    {
        let bounds = CGRect(width: 38, height: 38)
        let lineWidth: CGFloat = 3
        var radius: CGFloat = 10
        radius = radius - lineWidth * 0.5

        let strokeColor = UIColor(white: 1, alpha: 0.5)
        let fillColor = UIColor.clear

        // Paths
        //
        let radian = CGFloat.pi / 180
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = radian * 360
        shapePath.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

        shapeLayer.name = "Shape"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: 16, y: 16)
        shapeLayer.contentsGravity = .center
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.allowsGroupOpacity = true
        shapeLayer.transform = CATransform3DRotate(shapeLayer.transform, radian * 90, 0, 0, 1)

        shapeLayer.path = shapePath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeEnd = 0

        let strokeEndAnimation = CABasicAnimation()
        strokeEndAnimation.beginTime = 0.000001
        strokeEndAnimation.duration = 2
        strokeEndAnimation.fillMode = .forwards
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeEndAnimation.keyPath = "strokeEnd"
        strokeEndAnimation.toValue = 0

        self.addSublayer(shapeLayer)
        self.strokeEndAnimation = strokeEndAnimation
    }

    func setStrokeEnd(to: CGFloat, animated: Bool)
    {
        strokeEndAnimation!.beginTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        strokeEndAnimation!.duration = animated ? 0.3 : 0.0001
        strokeEndAnimation!.toValue = min(max(0, to), 1.0)
        shapeLayer.add(self.strokeEndAnimation!, forKey: "strokeEndAnimation")
    }
}
