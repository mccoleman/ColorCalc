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
    @State private var showingCreateColorWheelVC = false
    @State private var showingEditColorWheelVC = false
    @State private var newPalletteName = ""
    @State var selectedColorPalette:ColorPallette?
    
    var body: some View {
        VStack {
            List {
                ForEach(colorPallettes, id:\.self) { palette in
                    Button(palette.unwrappedTitle) {
                        showingEditColorWheelVC.toggle()
                    }
                    .tint(.black)
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            print("Delete")
                           deletePalettes(colorPalette: palette)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        Button {
                            print("Edit")
                        } label: {
                            Label("Edit", systemImage: "paintbrush")
                        }
                        .alert("Rename This Pallette", isPresented: $showingCreatePalletteAlert) {
                            TextField(palette.unwrappedTitle, text: $newPalletteName)
                            Button("Save and Create", action: renameSubmit)
                        }
                        .tint(.indigo)
                    }
                    .sheet(isPresented: $showingEditColorWheelVC) {
                        ColorWheelVCRepresentable(colorPalette: palette)
                    }
                }
                
            }
            Button("Create New Pallette"){
                showingCreatePalletteAlert.toggle()
            }
            .alert("Name This Pallette", isPresented: $showingCreatePalletteAlert) {
                TextField("Color Pallette #\(colorPallettes.count + 1)", text: $newPalletteName)
                Button("Save and Create", action: saveNameSubmit)
            }
            .sheet(isPresented: $showingCreateColorWheelVC, onDismiss: didDismssCreate) {
                if let p = selectedColorPalette {
                    ColorWheelVCRepresentable(colorPalette: p)
                }
            }
        }
    }
    
    func saveNameSubmit() {
        let pallette = ColorPallette(context: moc)
        pallette.title = newPalletteName
        let colorOption = ColorOption(context: moc)
        colorOption.hexString = "FFFFFF"
        pallette.colorOptions = [colorOption]
        try? moc.save()
        selectedColorPalette = pallette
        showingCreateColorWheelVC.toggle()
    }
    
    func didDismssCreate() {
        selectedColorPalette = nil
    }
    
    private func deletePalettes(colorPalette: ColorPallette) {
        withAnimation {
            moc.delete(colorPalette)

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
