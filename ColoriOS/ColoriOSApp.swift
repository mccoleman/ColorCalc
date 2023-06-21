//
//  ColoriOSApp.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/19/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//

import SwiftUI

@main
struct ColoriOSApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ColorPaletteSelection()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
    }
}

