//
//  HueView.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 11/2/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit

class HueView: UIView {

    let gradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white, UIColor.black]//Colors you want to add
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
       return gradientLayer
    }()
    
    var color:UIColor {
        didSet{
            self.buildGradientLayer()
        }
    }
    
    init(frame: CGRect, color:UIColor) {
        self.color = color
        super.init(frame: frame)
        self.buildGradientLayer()
    }
    
    override init(frame: CGRect) {
        self.color = UIColor.white
        super.init(frame: frame)
        self.buildGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        self.color = UIColor.white
        super.init(coder: coder)
//        self.gradientLayer.startPoint = CGPoint(x: 0, y: 1.0)
//        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(self.gradientLayer)
        self.gradientLayer.frame = self.bounds
        self.buildGradientLayer()
    }
    
    func buildGradientLayer() {
        self.gradientLayer.colors = [color, UIColor.black]
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
