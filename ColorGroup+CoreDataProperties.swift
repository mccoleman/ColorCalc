//
//  ColorGroup+CoreDataProperties.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/19/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//
//

import Foundation
import CoreData


extension ColorGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorGroup> {
        return NSFetchRequest<ColorGroup>(entityName: "ColorGroup")
    }

    @NSManaged public var colorHarmony: NSNumber?
    @NSManaged public var parent: ColorOption?
    @NSManaged public var childColorOptions: ColorOption?

    public var colorHarmonyAsEnum: ColorHarmony {
        guard let colorHarmonyInt = colorHarmony as? Int else {
            return .None
        }
        return ColorHarmony(rawValue: colorHarmonyInt) ?? .None
    }
}

extension ColorGroup : Identifiable {

}
