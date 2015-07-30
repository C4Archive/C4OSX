//
//  MOCoreWedge.swift
//  C4OSX
//
//  Created by travis on 2015-07-29.
//  Copyright © 2015 C4. All rights reserved.
//

import Foundation

public class MOCoreWedge : C4Wedge {
    convenience public init(center: C4Point, radius: Double, start: Double, end: Double, clockwise: Bool) {
        let wedgeRect = CGRectMakeFromWedge(CGPoint(center),radius: CGFloat(radius),startAngle: CGFloat(start),endAngle: CGFloat(end), clockwise: clockwise);
        self.init(frame: C4Rect(wedgeRect))
        let wedge = CGPathCreateMutable()
        CGPathAddArc(wedge, nil, CGFloat(center.x), CGFloat(center.y), CGFloat(radius), CGFloat(start), CGFloat(end), clockwise)
        CGPathAddLineToPoint(wedge, nil, CGFloat(center.x), CGFloat(center.y))
        self.path = C4Path(path: wedge)
        path?.closeSubpath()
        self.adjustToFitPath()

        var t = CGAffineTransformMakeTranslation(0,CGFloat(-height/2.0))
        let p = CGPathCreateCopyByTransformingPath(shapeLayer.path, &t)

        self.path = C4Path(path: p!)
    }
}