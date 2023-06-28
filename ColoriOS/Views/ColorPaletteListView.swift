//
//  ColorPaletteListView.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/28/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//

import SwiftUI

struct ColorPaletteListView: View {
    
    var colorPalette:ColorPallette
    let rows = [GridItem(.fixed(40), spacing:1), GridItem(.fixed(10))]
    
    var body: some View {
        VStack {
            HStack {
                LazyHGrid(rows: rows, alignment: .top, spacing: 0) {
                    ForEach(colorPalette.sortedColorOptions) { colorOption in
                        Color(uiColor: UIColor.colorFromHexString(hexString: colorOption.hexString)).frame(width: 40)
                        Text(colorOption.hexString)
                            .font(.system(size: 8))
                    }
                }
                Spacer()
            }
            HStack {
                Text(colorPalette.unwrappedTitle)
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .frame(height: 60)
        .padding(8)
    }
}

struct ColorPaletteListView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteListView(colorPalette: ColorPallette.basicInit(moc: PersistenceController.shared.container.viewContext, title: "Color Palette #1", hexString:"4423FF"))
    }
}
