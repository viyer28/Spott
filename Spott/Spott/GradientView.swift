//
//  GradientView.swift
//  spott
//
//  Created by Brendan Sanderson on 4/18/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
@IBDesignable
class GradientView: UIView {
    @IBInspectable var startColor: UIColor = C.eventDarkBrownColor
    @IBInspectable var endColor: UIColor = C.eventLightBrownColor

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: superview!.frame.size.width,
                                height: superview!.frame.size.height)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = -1
        layer.addSublayer(gradient)
    }
}
