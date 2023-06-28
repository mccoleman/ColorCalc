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
    @State private var showingRenamePalletteAlert = false
    @State private var showingCreateColorWheelVC = false
    @State private var showingEditColorWheelVC = false
    @State private var newPalletteName = ""
    @State var selectedColorPalette:ColorPallette?
    let rows = [GridItem(.fixed(40), spacing:1), GridItem(.fixed(10))]
    
    var body: some View {
        VStack {
            List {
                ForEach(colorPallettes, id:\.self) { palette in
                    VStack {
                        HStack {
                            LazyHGrid(rows: rows, alignment: .top, spacing: 0) {
                                ForEach(palette.sortedColorOptions) { colorOption in
                                    Color(uiColor: UIColor.colorFromHexString(hexString: colorOption.hexString)).frame(width: 40)
                                    Text(colorOption.hexString)
                                        .font(.system(size: 8))
                                }
                            }
                            Spacer()
                        }
                        HStack {
                            Text(palette.unwrappedTitle)
                            Spacer()
                        }
                    }
                    .onTapGesture {
                        selectedColorPalette = palette
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
                        .alert("Rename This Pallette", isPresented: $showingRenamePalletteAlert) {
                            TextField(palette.unwrappedTitle, text: $newPalletteName)
                            Button("Save and Create", action: renameSubmit)
                        }
                        .tint(.indigo)
                    }
                }
            }
            
            Button("Create New Palette"){
                showingCreatePalletteAlert.toggle()
            }
            .alert("Name This Palette", isPresented: $showingCreatePalletteAlert) {
                TextField("Color Palette #\(colorPallettes.count + 1)", text: $newPalletteName)
                Button("Save and Create", action: saveNameSubmit)
            }
            .sheet(isPresented: $showingCreateColorWheelVC, onDismiss: didDismssCreate) {
                if let p = selectedColorPalette {
                    ColorWheelVCRepresentable(colorPalette: p, newPalette: true)
                }
            }
            .sheet(isPresented: $showingEditColorWheelVC, onDismiss: didDismssCreate) {
                if let p = selectedColorPalette {
                    ColorWheelVCRepresentable(colorPalette:p, newPalette: false)
                }
            }
        }
    }
    
    func saveNameSubmit() {
        let pallette = ColorPallette(context: moc)
        pallette.title = newPalletteName == "" ? "Color Palette #\(colorPallettes.count + 1)" : newPalletteName
        pallette.createDate = Date()
        try? moc.save()
        selectedColorPalette = pallette
        showingCreateColorWheelVC.toggle()
    }
    
    func renameSubmit() {
        
    }
    
    func didDismssCreate() {
        selectedColorPalette = nil
        showingEditColorWheelVC = false
        showingCreateColorWheelVC = false
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
