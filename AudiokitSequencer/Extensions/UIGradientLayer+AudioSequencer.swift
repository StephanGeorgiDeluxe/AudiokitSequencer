//
//  AudioSequencer+UIGradientLayer.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 31.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

extension CAGradientLayer {

    func setColors(_ newColors: [CGColor],
                   fromColors: [CGColor],
                   animated: Bool = true,
                   autoreverse: Bool = false,
                   withDuration duration: TimeInterval = 0,
                   timingFunctionName name: CAMediaTimingFunctionName? = nil) {

        if !animated {
            self.colors = newColors
            return
        }

        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = fromColors
        colorAnimation.toValue = newColors
        colorAnimation.duration = duration
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.fillMode = CAMediaTimingFillMode.forwards
        colorAnimation.timingFunction = CAMediaTimingFunction(name: name ?? .easeOut)
        colorAnimation.autoreverses = autoreverse
        add(colorAnimation, forKey: "colorsChangeAnimation")
    }
}
