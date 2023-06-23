//
//  ColorWheelView.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/19/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//

import SwiftUI

struct ColorWheelVCRepresentable: UIViewControllerRepresentable {
    
    let colorPalette: ColorPallette
    
    func makeUIViewController(context: Context) -> ColorWheelViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "ColorWheelViewController") as! ColorWheelViewController
        
        vc.colorPalette = colorPalette
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ColorWheelViewController, context: Context) {
        
    }
    
}
