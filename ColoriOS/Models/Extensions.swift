//
//  Extensions.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 10/28/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    func getPixelColorAt(point: CGPoint) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(
            data: pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )

        context!.translateBy(x: -point.x, y: -point.y)
        layer.render(in: context!)
        let color = UIColor(
            red: CGFloat(pixel[0]) / 255.0,
            green: CGFloat(pixel[1]) / 255.0,
            blue: CGFloat(pixel[2]) / 255.0,
            alpha: CGFloat(pixel[3]) / 255.0
        )

        pixel.deallocate()
        return color
    }
}

extension UIView {
    func quadrantInView(view:UIView) -> Quadrant{
        
        if self.bounds.contains(view.center) {
            if view.center.x > self.center.x {
                if view.center.y < self.center.y{
                    return .I
                }
                return .IV
            } else {
                if view.center.y < self.center.y{
                    return .II
                }
                return .III
            }
        }
        return .I
    }
}

extension CGRect {
    func containsWholeRect(rect:CGRect){
        
    }
}

