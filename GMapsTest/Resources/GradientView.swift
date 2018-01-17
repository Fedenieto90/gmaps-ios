//
//  GradientView.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/10/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
        ]
        backgroundColor = UIColor.clear
    }
}
