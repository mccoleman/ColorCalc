//
//  ColorSelectorView.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 10/28/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit

class ColorSelectorView: UIView {
    
    var color:UIColor
    var colorOption:ColorOption
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = rect.width/2
        self.layer.borderWidth = 2
    }
    
    init(frame:CGRect, color:UIColor, colorOption:ColorOption){
        self.color = color
        self.colorOption = colorOption
        super.init(frame: frame)
    }
    
    func setColor(color:UIColor) {
        self.color = color
        self.colorOption.hexString = color.hex
    }
    
    func setCenterPoint(point:CGPoint) {
        self.colorOption.xPoint = point.x as NSNumber
        self.colorOption.yPoint = point.y as NSNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
