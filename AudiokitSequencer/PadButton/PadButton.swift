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
        renderer.updateBounds(CGRect(width: SequencerFactory.dimension, height: SequencerFactory.dimension))
        renderer.state = .idle
        layer.addSublayer(renderer.gradientLayer)
        layer.addSublayer(renderer.strokeLayer)
        layer.addSublayer(renderer.highlightLayer)
    }

    func didTouchButton() {
        renderer.showTouch()
    }

    func showHighlight() {
        renderer.showHighlight()
    }
}
