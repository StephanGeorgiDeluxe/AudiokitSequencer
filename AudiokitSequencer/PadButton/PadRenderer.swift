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
            highlightLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
            gradientLayer.colors = [color.lighter(by: 5).cgColor, color.darker(by: 15).cgColor]
        }
    }

    var level: CGFloat {
        get { return levelLayer.level }
        set {
            levelLayer.level = newValue
            updatePadColors(state: state)
        }
    }
    var bounds: CGRect = .zero

    let gradientLayer = GradientLayer()
    let highlightLayer = GradientLayer()
    let levelLayer = CircularLevelShapeLayer()

    var state: PadState = .idle {
        didSet {
            updatePadColors(state: state)
        }
    }

    init(padState: PadState) {
        state = padState
        gradientLayer.setUp()
        highlightLayer.setUp()
        levelLayer.setUp()
    }

    func updateBounds(_ bounds: CGRect) {
        self.bounds = bounds
        gradientLayer.update(bounds: bounds)
        highlightLayer.update(bounds: bounds)
        levelLayer.update(bounds: bounds)

        updatePadColors(state: state)
    }

    private func updatePadColors(state: PadState) {
        switch state {
        case .idle:
            color = .padIdle
        case .active:
            let minDarkness: CGFloat = 35
            let darker: CGFloat = minDarkness * (1-level)
            let brightnessColor = UIColor.padActive
            color = brightnessColor.darker(by: darker)
        }
    }

    func showTouch() {
        gradientLayer.setColors([color.cgColor, color.darker(by: 15).cgColor],
                                fromColors: [color.cgColor, color.lighter().cgColor],
                                withDuration: PadRenderer.animationDuration)
    }

    func showHighlight() {
        highlightLayer.setColors([UIColor.clear.cgColor, UIColor.clear.cgColor],
                                 fromColors: [UIColor.padHighlight.cgColor, UIColor.padHighlight.darker(by: 15).cgColor],
                                 withDuration: PadRenderer.animationDuration)
    }
}
