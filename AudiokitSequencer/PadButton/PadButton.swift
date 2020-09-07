//
//  PadButton.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 27.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

class PadButton: UIControl {
    private let renderer = PadRenderer(padState: .active)
    private let gestures = PadGestures()

    private let gestureRecognizer = UIPanGestureRecognizer()

    var colorIntensity: CGFloat = 0 {
        didSet {
            renderer.setLevel(colorIntensity)
        }
    }

    var lineWidth: CGFloat {
        get { return renderer.lineWidth }
        set { renderer.lineWidth = newValue }
    }

    var padState: PadState = .idle {
        didSet {
            renderer.state = padState
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpElements()
    }

    private func setUpElements() {
        backgroundColor = .clear

        setUpRenderer()
        addLayer()
        setUpGestures()
    }

    private func setUpRenderer() {
        renderer.updateBounds(CGRect(width: SequencerFactory.dimension,
                                     height: SequencerFactory.dimension))
        renderer.state = .idle
    }

    private func addLayer() {
        layer.addSublayer(renderer.gradientLayer)
        layer.addSublayer(renderer.strokeLayer)
        layer.addSublayer(renderer.levelLayer.shapeLayer)
        layer.addSublayer(renderer.highlightLayer)
    }

    private func setUpGestures() {
        gestures.setUpGestures(view: self)
        gestures.panAction = { [weak self] (change) in
            guard let self = self else { return }
            let minOffset: CGFloat = 0.02
            let currentLevel = self.renderer.levelLayer.level
            let distance = sqrt(pow(change.x, 2.0) + pow(change.y, 2.0))
            let offset = max(distance/100, minOffset)
            let level = change.y > 0 ? currentLevel - offset : currentLevel + offset
            let changeLevel = max(0, min(1, level))

            self.renderer.setLevel(changeLevel)
        }
    }
}

extension PadButton {
    func didTouchButton() {
        renderer.showTouch()
    }

    func showHighlight() {
        renderer.showHighlight()
    }
}
