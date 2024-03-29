//
//  ColorOption+CoreDataClass.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/19/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ColorOption)
public class ColorOption: NSManagedObject {
    
    static func basicInit(context:NSManagedObjectContext, owner:ColorPallette, point:CGPoint, hexString:String = "FFFFFF") -> ColorOption {
        let colorOption = ColorOption(context: context)
        colorOption.createDate = Date()
        colorOption.hexString = hexString
        colorOption.owner = owner
        colorOption.xPoint = (point.x) as NSNumber
        colorOption.yPoint = (point.y) as NSNumber
        return colorOption
    }
    
    static func basicInit(context:NSManagedObjectContext, owner:ColorPallette, hexString:String = "FFFFFF") -> ColorOption {
        let colorOption = ColorOption(context: context)
        colorOption.createDate = Date()
        colorOption.hexString = hexString
        colorOption.owner = owner
        colorOption.xPoint = 0.0
        colorOption.yPoint = 0.0
        return colorOption
    }
}
