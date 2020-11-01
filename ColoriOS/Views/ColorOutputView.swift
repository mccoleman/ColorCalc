//
//  ColorOutputView.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 10/31/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit

class ColorOutputView: UIView {

    var color:UIColor{
        didSet{
            self.backgroundColor = color
        }
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.borderWidth = 2
    }
    
   init(frame: CGRect, color:UIColor) {
        self.color = color
        super.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        self.color = UIColor.white
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
