//
//  ColorWheelView.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 10/28/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit

class ColorWheelView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let filter = CIFilter(name: "CIHueSaturationValueGradient", parameters: [
        "inputColorSpace": CGColorSpaceCreateDeviceRGB(),
        "inputDither": 0,
        "inputRadius": 160,
        "inputSoftness": 0,
        "inputValue": 1
    ])!
    
    func renderColorWheel(){
        if let image = filter.outputImage {
            self.image = UIImage(ciImage: image)
        }
    }
}
