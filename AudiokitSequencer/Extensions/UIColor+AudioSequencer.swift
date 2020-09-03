//
//  AudioSequencer+UIColor.swift
//  AudiokitSequencer
//
//  Created by Georgi, Stephan on 31.08.20.
//  Copyright © 2020 Georgi, Stephan. All rights reserved.
//

import UIKit

extension UIColor {

    static let padBlue = UIColor(red: 0, green: 153/255, blue: 153/255, alpha: 1)
    static let padBlueDark = UIColor(red: 51/255, green: 136/255, blue: 136/255, alpha: 1)
    static let padBlueLight = UIColor(red: 85/255, green: 187/255, blue: 170/255, alpha: 1)
    static let padSand = UIColor(red: 238/255, green: 221/255, blue: 153/255, alpha: 1)
    static let padHighlight = UIColor(red: 105/255, green: 207/255, blue: 190/255, alpha: 0.5)

    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage)) ?? self
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage)) ?? self
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
