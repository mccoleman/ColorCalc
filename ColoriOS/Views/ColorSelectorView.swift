//
//  ColorSelectorView.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 10/28/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import UIKit

class ColorSelectorView: UIView {
    
    var colorOutput:ColorOutputView
    
    var color:UIColor {
        didSet{
            self.colorOutput.backgroundColor = color
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = rect.width/2
        self.layer.borderWidth = 2
    }

    override init(frame: CGRect) {
        self.colorOutput = ColorOutputView(frame:CGRect(
            x: 0,
            y: 0,
            width: 50,
            height: 50)
        )

        self.color = UIColor.white
        super.init(frame: frame)
    }
    
    init(frame:CGRect,color:UIColor){
        self.colorOutput = ColorOutputView(frame:CGRect(
            x: 0,
            y: 0,
            width: 50,
            height: 50)
        )

        self.color = color
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
