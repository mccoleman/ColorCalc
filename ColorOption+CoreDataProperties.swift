//
//  ColorOption+CoreDataProperties.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/19/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//
//

import Foundation
import CoreData


extension ColorOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorOption> {
        return NSFetchRequest<ColorOption>(entityName: "ColorOption")
    }

    @NSManaged public var hexString: String?
    @NSManaged public var owner: ColorPallette?
    @NSManaged public var createDate:Date?
    @NSManaged public var colorGroup: ColorGroup?

}

// MARK: Generated accessors for colorGroup
extension ColorOption {

    @objc(addColorGroupObject:)
    @NSManaged public func addToColorGroup(_ value: ColorGroup)

    @objc(removeColorGroupObject:)
    @NSManaged public func removeFromColorGroup(_ value: ColorGroup)

    @objc(addColorGroup:)
    @NSManaged public func addToColorGroup(_ values: NSSet)

    @objc(removeColorGroup:)
    @NSManaged public func removeFromColorGroup(_ values: NSSet)

}

extension ColorOption : Identifiable {

}
