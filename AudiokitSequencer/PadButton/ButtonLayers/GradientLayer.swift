//
//  GradientLayer.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 21.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

class GradientLayer: CAGradientLayer, ButtonLayer {
    func setUp() {
        type = .radial
        locations = [0.0, 1.0]
    }

    func update(bounds: CGRect) {
        frame = bounds
        startPoint = CGPoint(x: 0.5, y: 0.5)
        endPoint = CGPoint(x: 1.5, y: 1.5)
        cornerRadius = bounds.width/10
    }
}
