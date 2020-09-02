//
//  PadRenderer.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 28.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

enum PadState {
    case idle
    case active
}

class PadRenderer {
    static let animationDuration: TimeInterval = 0.3
    var color: UIColor = .blue {
        didSet {
            strokeLayer.strokeColor = color.cgColor
            let secondColor = color.darker(by: 15)
            gradientLayer.colors = [color.cgColor, secondColor.cgColor]
            updateGradientLayer()
        }
    }

    let strokeLayer = CAShapeLayer()
    let gradientLayer = CAGradientLayer()
    private let maskLayer = CAShapeLayer()

    var state: PadState = .idle {
        didSet {
            updatePadColors(state: state)
        }
    }

    var lineWidth: CGFloat = 0 {
        didSet {
            strokeLayer.lineWidth = lineWidth
            updateStrokeLayerPath()
        }
    }

    private func updateStrokeLayerPath() {
        let rect = roundedRect(layer: strokeLayer)
        strokeLayer.path = rect.cgPath
    }

    private func roundedRect(layer: CALayer) -> UIBezierPath {
        let bounds = layer.bounds
        let rectbounds = CGRect(x: bounds.minX + lineWidth,
                                y: bounds.minY + lineWidth,
                                width: bounds.width - 2 * lineWidth,
                                height: bounds.height - 2 * lineWidth)

        let rect = UIBezierPath(roundedRect: rectbounds, cornerRadius: rectbounds.width/10)
        return rect
    }

    init(padState: PadState) {
        state = padState
        strokeLayer.fillColor = UIColor.clear.cgColor
        setUpGradientLayer()
    }

    private func setUpGradientLayer() {
        gradientLayer.type = .radial
        gradientLayer.locations = [0.0, 1.0]
    }

    func updateBounds(_ bounds: CGRect) {
        strokeLayer.bounds = bounds
        strokeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updateStrokeLayerPath()
        updateGradientLayer()
        updateMaskLayer()
    }

    private func updateGradientLayer() {
        let bounds = strokeLayer.bounds
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.5, y: 1.5)
    }

    private func updateMaskLayer() {
        maskLayer.frame = strokeLayer.bounds
        let rect = roundedRect(layer: maskLayer)
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = rect.cgPath
        gradientLayer.mask = maskLayer
    }

    private func updatePadColors(state: PadState) {
        switch state {
        case .idle:
            color = .padBlueLight
        case .active:
            color = .padSand
        }
    }

    func showHighlight() {
        gradientLayer.setColors([color.cgColor, color.darker(by: 15).cgColor], fromColors: [color.cgColor, color.lighter().cgColor], withDuration: PadRenderer.animationDuration)
    }
}
