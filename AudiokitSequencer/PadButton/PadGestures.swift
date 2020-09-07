//
//  PadGestures.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 07.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

class PadGestures {
    var panAction: ((CGPoint) -> Void)?

    private let gestureRecognizer = UIPanGestureRecognizer()
    private weak var view: UIView?

    func setUpGestures(view: UIView) {
        gestureRecognizer.addTarget(self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        self.view = view
    }

    @objc
    private func didPan(_ gestureRecognizer : UIPanGestureRecognizer ) {
        guard gestureRecognizer.view != nil else { return }
        switch gestureRecognizer.state {

        case .possible:
            print("pan: possible")
        case .began:
            print("pan: began")
        case .changed:
            panAction?(gestureRecognizer.translation(in: view))
            gestureRecognizer.setTranslation(.zero, in: view)
        case .ended:
            print("pan: ended")
        case .cancelled:
            print("pan: cancelled")
        case .failed:
            print("pan: failed")
        @unknown default:
            break
        }
    }
}
