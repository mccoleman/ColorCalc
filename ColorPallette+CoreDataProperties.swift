//
//  ColorPallette+CoreDataProperties.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/19/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//
//

import Foundation
import CoreData


extension ColorPallette {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorPallette> {
        return NSFetchRequest<ColorPallette>(entityName: "ColorPallette")
    }

    @NSManaged public var title: String?
    @NSManaged public var colorOptions: NSSet?
    @NSManaged public var createDate:Date
    
    public var unwrappedTitle: String {
        return title ?? "unknown Title"
    }
    
    public var sortedColorOptions: [ColorOption] {
        guard let set = colorOptions as? Set<ColorOption> else {
            return []
        }
        
        return set.sorted {
            $0.createDate > $1.createDate
        }
    }
}

// MARK: Generated accessors for colorOptions
extension ColorPallette {

    @objc(addColorOptionsObject:)
    @NSManaged public func addToColorOptions(_ value: ColorOption)

    @objc(removeColorOptionsObject:)
    @NSManaged public func removeFromColorOptions(_ value: ColorOption)

    @objc(addColorOptions:)
    @NSManaged public func addToColorOptions(_ values: NSSet)

    @objc(removeColorOptions:)
    @NSManaged public func removeFromColorOptions(_ values: NSSet)

}

extension ColorPallette : Identifiable {

}
