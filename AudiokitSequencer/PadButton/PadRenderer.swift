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
    static let animationDuration: TimeInterval = 0.2
    var color: UIColor = .blue {
        didSet {
            strokeLayer.strokeColor = color.cgColor
            let secondColor = color.darker(by: 15)
            gradientLayer.colors = [color.cgColor, secondColor.cgColor]
            highlightLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
            updateGradientLayer()
        }
    }

    let strokeLayer = CAShapeLayer()
    let gradientLayer = CAGradientLayer()
    let highlightLayer = CAGradientLayer()
    let levelLayer = CircularLevelShapeView()

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
        setUpHighlightLayer()
    }

    private func setUpGradientLayer() {
        gradientLayer.type = .radial
        gradientLayer.locations = [0.0, 1.0]
    }

    private func setUpHighlightLayer() {
        highlightLayer.type = .radial
        highlightLayer.locations = [0.0, 1.0]
    }

    func updateBounds(_ bounds: CGRect) {
        strokeLayer.bounds = bounds
        strokeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updateStrokeLayerPath()
        updateGradientLayer()
        updateHighlightLayer()
        updateMaskLayer()
    }

    private func updateGradientLayer() {
        let bounds = strokeLayer.bounds
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.5, y: 1.5)
    }

    private func updateHighlightLayer() {
        let bounds = strokeLayer.bounds
        highlightLayer.frame = bounds
        highlightLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        highlightLayer.endPoint = CGPoint(x: 1.5, y: 1.5)
    }

    private func updateMaskLayer() {
        maskLayer.frame = strokeLayer.bounds
        let rect = roundedRect(layer: maskLayer)
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = rect.cgPath
        gradientLayer.mask = maskLayer
        highlightLayer.mask = maskLayer
    }

    private func updatePadColors(state: PadState) {
        switch state {
        case .idle:
            color = .padBlueLight
            levelLayer.setStrokeEnd(to: 0, animated: false)
        case .active:
            color = .padSand
            levelLayer.setStrokeEnd(to: 1.0, animated: true)
        }
    }

    func showTouch() {
        gradientLayer.setColors([color.cgColor, color.darker(by: 15).cgColor], fromColors: [color.cgColor, color.lighter().cgColor], withDuration: PadRenderer.animationDuration)
    }

    func showHighlight() {
        highlightLayer.setColors([UIColor.clear.cgColor, UIColor.clear.cgColor], fromColors: [UIColor.white.cgColor, UIColor.white.darker(by: 15).cgColor], withDuration: PadRenderer.animationDuration)
    }
}
