//
//  UIControl+AudioSequencer.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 03.09.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

typealias VoidClosure = (() -> Void)

@objc class ClosureSleeve: NSObject {
    let closure: VoidClosure

    init (_ closure: @escaping VoidClosure) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping VoidClosure) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
