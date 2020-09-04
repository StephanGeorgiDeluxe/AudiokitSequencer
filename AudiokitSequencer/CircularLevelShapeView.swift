//
//  CircularLevelShapeView.swift
//  Exported from Kite Compositor for Mac 2.0.2
//
//  Created on 04.09.20, 12:51.
//


import UIKit

class CircularLevelShapeView: UIView
{
    // MARK: - Properties

    var shapeLayer: CAShapeLayer?
    private var strokeEndAnimation: CABasicAnimation?

    // MARK: - Initialization

    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 720, height: 494))
        self.setupLayers()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupLayers()
    }

    // MARK: - Setup Layers

    private func setupLayers()
    {
        // Colors
        //
        let borderColor = UIColor(red: 0.795254, green: 0.795254, blue: 0.795254, alpha: 0)
        let fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let strokeColor = UIColor(red: 0.179492, green: 0.363012, blue: 0.659826, alpha: 1)

        // Paths
        //
        let shapePath = CGMutablePath()
        shapePath.move(to: CGPoint(x: 34, y: 19))
        shapePath.addCurve(to: CGPoint(x: 19, y: 34), control1: CGPoint(x: 34, y: 27.284271), control2: CGPoint(x: 27.284271, y: 34))
        shapePath.addCurve(to: CGPoint(x: 4, y: 19), control1: CGPoint(x: 10.715729, y: 34), control2: CGPoint(x: 4, y: 27.284271))
        shapePath.addCurve(to: CGPoint(x: 19, y: 4), control1: CGPoint(x: 4, y: 10.715729), control2: CGPoint(x: 10.715729, y: 4))
        shapePath.addCurve(to: CGPoint(x: 34, y: 19), control1: CGPoint(x: 27.284271, y: 4), control2: CGPoint(x: 34, y: 10.715729))
        shapePath.closeSubpath()
        shapePath.move(to: CGPoint(x: 34, y: 19))

        // Shape
        //
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "Shape"
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: 38, height: 38)
        shapeLayer.position = CGPoint(x: 16, y: 16)
        shapeLayer.contentsGravity = .center
        shapeLayer.borderWidth = 1
        shapeLayer.borderColor = borderColor.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.allowsGroupOpacity = true
        shapeLayer.fillMode = .forwards
        shapeLayer.transform = CATransform3D( m11: -0.087156, m12: 0.996195, m13: 0, m14: 0,
                                              m21: -0.996195, m22: -0.087156, m23: 0, m24: 0,
                                              m31: 0, m32: 0, m33: 1, m34: 0,
                                              m41: 0, m42: 0, m43: 0, m44: 1 )

        // Shape Animations
        //

        // strokeEnd
        //
        let strokeEndAnimation = CABasicAnimation()
        strokeEndAnimation.beginTime = 0.000001
        strokeEndAnimation.duration = 0.1
        strokeEndAnimation.fillMode = .forwards
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        strokeEndAnimation.keyPath = "strokeEnd"
        strokeEndAnimation.toValue = 1

        shapeLayer.path = shapePath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineDashPattern = [ 2.6 ]
        shapeLayer.lineWidth = 3
        shapeLayer.strokeEnd = 0.75

        self.layer.addSublayer(shapeLayer)

        // Layer Instance Assignments
        //
        self.shapeLayer = shapeLayer

        // Animation Instance Assignments
        //
        self.strokeEndAnimation = strokeEndAnimation

    }

    // MARK: - Actions

    func setStrokeEnd(to: CGFloat, animated: Bool)
    {
        strokeEndAnimation!.beginTime = shapeLayer!.convertTime(CACurrentMediaTime(), from: nil)
        strokeEndAnimation!.duration = animated ? 0.3 : 0.1
        strokeEndAnimation!.toValue = min(max(0, to), 1.0)
        shapeLayer?.add(self.strokeEndAnimation!, forKey: "strokeEndAnimation")
    }
}
