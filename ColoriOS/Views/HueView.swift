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
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
       return gradientLayer
    }()
    
    var color:UIColor {
        didSet{
            self.buildGradientLayer()
        }
    }
    
    required init?(coder: NSCoder) {
        self.color = UIColor.white
        super.init(coder: coder)
        self.layer.addSublayer(self.gradientLayer)
        self.gradientLayer.frame = self.bounds
        self.buildGradientLayer()
    }
    
    func buildGradientLayer() {
        self.gradientLayer.colors = [color.cgColor, UIColor.black.cgColor]
        self.gradientLayer.frame = self.bounds
        self.layer.addSublayer(self.gradientLayer)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.buildGradientLayer()
    }
    

}
