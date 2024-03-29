//
//  Constants.swift
//  ColoriOS
//
//  Created by Michaiah Coleman on 10/29/20.
//  Copyright © 2020 Michaiah Coleman. All rights reserved.
//

import Foundation
import UIKit

let ANALOGOUS_ANGLE_OFFSET:CGFloat = 15
let TRIADIC_ANGLE_OFFSET:CGFloat = 120
let TETRADIC_ANGLE_OFFSET:CGFloat = 90
let SPLIT_ANGLE_OFFSET:CGFloat = 30
let OPPOSITE_ANGLE_OFFSET:CGFloat = 180
let SELECTOR_SIZE:CGFloat = 20
let MONO_RADIUS_DELTA:CGFloat = 40

func complementaryOrigin(center:CGPoint, basePoint:CGPoint,quadrant:Quadrant) -> CGPoint {
    let width = abs(center.x - basePoint.x)
    let height = abs(center.y - basePoint.y)
    
    switch(quadrant.getOpposite()){
    case .I:
        return CGPoint(x: center.x + width, y: center.y - height)
    case .II:
        return CGPoint(x: center.x - width, y: center.y - height)
    case .III:
        return CGPoint(x: center.x - width, y: center.y + height)
    case .IV:
        return CGPoint(x: center.x + width, y: center.y + height)
    }
    
}

func getOriginsForColorHarmony(center:CGPoint, basePoint:CGPoint,quadrant:Quadrant, harmony:ColorHarmony) -> [CGPoint]{
    
    let tuple = getRadiusAndAngle(center: center, basePoint: basePoint, quadrant: quadrant)
    var newAngles:[CGFloat] = []
    switch harmony {
    case .Complementary:
        newAngles = [tuple.angle + OPPOSITE_ANGLE_OFFSET]
    case .Analogous:
        newAngles = [tuple.angle + ANALOGOUS_ANGLE_OFFSET,
                    tuple.angle - ANALOGOUS_ANGLE_OFFSET
        ]
    case .Mono:
        newAngles = [tuple.angle]
        break
    case .Split:
        newAngles = [tuple.angle + OPPOSITE_ANGLE_OFFSET - SPLIT_ANGLE_OFFSET,
                     tuple.angle + OPPOSITE_ANGLE_OFFSET + SPLIT_ANGLE_OFFSET
        ]
        break
    case .Triadic:
        newAngles = [tuple.angle + TETRADIC_ANGLE_OFFSET,
                    tuple.angle + TRIADIC_ANGLE_OFFSET*2
        ]
    case .Tetradic:
        newAngles = [tuple.angle + TETRADIC_ANGLE_OFFSET,
                    tuple.angle + TETRADIC_ANGLE_OFFSET*2,
                    tuple.angle + TETRADIC_ANGLE_OFFSET*3
        ]
    default:
        break
    }
    
    
    var newPoints:[CGPoint] = []
    
    for angle in newAngles {
        newPoints.append(
            getPointFromAngleAndRadius(
                angle: angle,
                radius: harmony  != .Mono ? tuple.radius : max(0,tuple.radius - MONO_RADIUS_DELTA),
                center: center))
    }
    return newPoints
}

func getLengthFromAngleAndRadiusCos(angle:CGFloat,radius:CGFloat) -> CGFloat{
    return radius * sin((angle*CGFloat.pi)/180.0)
}

func getLengthFromAngleAndRadiusSin(angle:CGFloat,radius:CGFloat) -> CGFloat{
    return radius * cos((angle*CGFloat.pi)/180.0)
}

func getRadiusAndAngle(center:CGPoint, basePoint:CGPoint,quadrant:Quadrant) -> (radius:CGFloat, angle:CGFloat){
    let width = abs(center.x - basePoint.x)
    let height = abs(center.y - basePoint.y)
    let radius = hypot(width, height)
    
    var initialAngle:CGFloat = 0.0
    switch quadrant{
    case .I, .III:
        initialAngle = ((acos(width/radius)*180)/CGFloat.pi) + 90*CGFloat(quadrant.rawValue-1)
    case .II, .IV:
        initialAngle = ((acos(height/radius)*180)/CGFloat.pi) + 90*CGFloat(quadrant.rawValue-1)
    }
    
    return (radius,initialAngle.isNaN ? 0.0 : initialAngle)
}

func getPointFromAngleAndRadius(angle:CGFloat,radius:CGFloat, center:CGPoint) -> CGPoint {
    switch (angle.truncatingRemainder(dividingBy: 360)) {
    case 0...90: //height: sin width: cos
        let width = getLengthFromAngleAndRadiusSin(angle: angle, radius: radius)
        let height = getLengthFromAngleAndRadiusCos(angle: angle, radius: radius)
        return (CGPoint(x: center.x + width, y: center.y - height))
    case 90...180://height: cos width: sin
        let angleInQuadrant = angle - 90
        let width = getLengthFromAngleAndRadiusCos(angle: angleInQuadrant, radius: radius)
        let height = getLengthFromAngleAndRadiusSin(angle: angleInQuadrant, radius: radius)
        return CGPoint(x: center.x - width , y: center.y - height)
    case 180...270: //height: sin width: cos
        let angleInQuadrant = angle - 180
        let width = getLengthFromAngleAndRadiusSin(angle: angleInQuadrant, radius: radius)
        let height = getLengthFromAngleAndRadiusCos(angle: angleInQuadrant, radius: radius)
        return CGPoint(x: center.x - width , y: center.y + height)
    case 270...360://height: cos width: sin
        let angleInQuadrant = angle - 270
        let width = getLengthFromAngleAndRadiusCos(angle: angleInQuadrant, radius: radius)
        let height = getLengthFromAngleAndRadiusSin(angle: angleInQuadrant, radius: radius)
        return CGPoint(x: center.x + width, y: center.y + height)
    case _ where angle < 0:
        return getPointFromAngleAndRadius(angle: 360 + angle.truncatingRemainder(dividingBy: 360), radius:radius , center: center)
    default:
        return CGPoint(x: 0, y: 0)
    }
}

