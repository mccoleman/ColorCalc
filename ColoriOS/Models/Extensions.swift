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
    /* Picked up this color func from https://noahgilmore.com/blog/cifilter-colorwheel/ */
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
    func quadrantInView(viewCenter:CGPoint) -> Quadrant{
        
        if self.bounds.contains(viewCenter) {
            if viewCenter.x > self.center.x {
                if viewCenter.y < self.center.y{
                    return .I
                }
                return .IV
            } else {
                if viewCenter.y < self.center.y{
                    return .II
                }
                return .III
            }
        }
        return .I
    }
}

extension UIColor{
    var hex:String {
        get{
            if let values = self.cgColor.components, values.count >= 3 {
                let r: CGFloat = values[0]
                let g: CGFloat = values[1]
                let b: CGFloat = values[2]

                let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
                return hexString
            } else {
                return "#000000"
            }
        }
    }
    
    public func colorWithBrightness(brightness: CGFloat) -> UIColor {
           var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
           
           if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
               B += (brightness - 1.0)
               B = max(min(B, 1.0), 0.0)
               
               return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
           }
           
           return self
       }
    
    public static func colorFromHexString(hexString:String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return .white
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


