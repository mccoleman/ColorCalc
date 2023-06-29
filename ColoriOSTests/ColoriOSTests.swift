//
//  ColoriOSTests.swift
//  ColoriOSTests
//
//  Created by Michaiah Coleman on 5/6/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import XCTest
@testable import ColoriOS

class ColoriOSTests: XCTestCase {

    var coreDataStack: TestCoreDataStack!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
        super.setUp()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        coreDataStack = nil
    }

    func testAddAColorPaletteWithBasicInit() throws {
        let palette = ColorPallette.basicInit(moc: coreDataStack.persistentContainer.viewContext, title: "Color Palette #1")
        
        XCTAssertTrue(palette.unwrappedTitle == "ColorPalette #1")
        XCTAssertNotNil(palette.colorOptions, "There should be a created colorOption")
        XCTAssertTrue(palette.colorOptions?.count == 1, "There should only be one created colorOption")
        XCTAssertTrue(palette.sortedColorOptions.first?.hexString == "#FFFFFF")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
