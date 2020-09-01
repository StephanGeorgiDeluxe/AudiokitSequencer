//
//  UIView+AudioSequencer.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 01.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

extension UIView {
    func addFittingSubview(_ view: UIView, insets: UIEdgeInsets = .zero, atIndex index: Int? = nil) {
        if let index = index {
            insertSubview(view, at: index)
        } else {
            addSubview(view)
        }
        view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom).isActive = true
    }
}
