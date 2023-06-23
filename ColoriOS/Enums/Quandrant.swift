//
//  Quandrant.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 6/20/23.
//  Copyright © 2023 Michaiah Coleman. All rights reserved.
//

import Foundation

public enum Quadrant:Int {
    case  I=1, II, III, IV
    
    func getOpposite() -> Quadrant{
        let truth:Int = (self.rawValue+2)%4
        return ((truth != 0) ? Quadrant(rawValue: truth)! : .IV)
    }
    
    func getQuadrantFromPoints(center:CGPoint, point:CGPoint) -> Quadrant{
        if point.x > center.x {
            if point.y < center.y{
                return .I
            }
            return .IV
        } else {
            if point.y < center.y{
                return .II
            }
            return .III
        }
    }
}
