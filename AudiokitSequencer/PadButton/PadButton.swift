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
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        renderer.updateBounds(CGRect(width: PadButtonFactory.dimension, height: PadButtonFactory.dimension))
        renderer.state = .idle
        layer.addSublayer(renderer.gradientLayer)
        layer.addSublayer(renderer.strokeLayer)
    }

    func didTouchButton() {
        renderer.showHighlight()
    }

    func showHighlight() {
        renderer.showHighlight()
    }
}