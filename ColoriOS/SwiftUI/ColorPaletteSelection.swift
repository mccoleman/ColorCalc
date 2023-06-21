//
//  ColorPaletteSelection.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/14/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//

import SwiftUI

struct ColorPaletteSelection: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var colorPallettes: FetchedResults<ColorPallette>
    
    @State private var showingCreatePalletteAlert = false
    @State private var showingColorWheelVC = false
    @State private var newPalletteName = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(colorPallettes, id:\.self) { pallette in
                    NavigationLink {
                        ColorWheelVCRepresentable()
                    } label: {
                        Text(pallette.unwrappedTitle)
                    }
                }.onDelete(perform: deletePalettes)
                
            }
            Button("Create New Pallette"){
                showingCreatePalletteAlert.toggle()
            }
            .alert("Name This Pallette", isPresented: $showingCreatePalletteAlert) {
                TextField("Color Pallette #\(colorPallettes.count + 1)", text: $newPalletteName)
                Button("Save and Create", action: submit)
            }
        }
        .sheet(isPresented: $showingColorWheelVC) {
            ColorWheelVCRepresentable()
        }
    }
    
    func submit() {
        let pallette = ColorPallette(context: moc)
        pallette.title = newPalletteName
        try? moc.save()
        showingColorWheelVC.toggle()
    }
    
    private func deletePalettes(offsets: IndexSet) {
        withAnimation {
            offsets.map { colorPallettes[$0] }.forEach(moc.delete)

            do {
                try moc.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ColorPaletteSelection_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteSelection()
    }
}
