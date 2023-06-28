//
//  ColorPallette+CoreDataClass.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/19/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ColorPallette)
public class ColorPallette: NSManagedObject {

    static func basicInit(moc:NSManagedObjectContext, title:String, hexString:String = "FFFFFF") -> ColorPallette {
        let colorPalette = ColorPallette(context: moc)
        colorPalette.title = title
        colorPalette.colorOptions = [ColorOption.basicInit(context: moc, owner: colorPalette,hexString: hexString)]
        
        return colorPalette
    }
}
