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
            self.hexReadout.text = "\(color.hex)"
        }
    }
    
    var hexReadout:UILabel = UILabel()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.borderWidth = 2
        self.hexReadout.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
        self.hexReadout.textAlignment = .center
        self.hexReadout.backgroundColor = UIColor.black
        self.hexReadout.textColor = UIColor.white
        self.addSubview(self.hexReadout)
    }
    
   init(frame: CGRect, color:UIColor) {
        self.color = color
        super.init(frame: frame)
        self.backgroundColor = color
    }
    
    override init(frame: CGRect) {
        self.color = UIColor.white
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
