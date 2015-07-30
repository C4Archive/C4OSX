//
//  C4View+FrameRotation.swift
//  C4OSX
//
//  Created by travis on 2015-07-29.
//  Copyright © 2015 C4. All rights reserved.
//

extension C4View {
    public var frameRotation : Double {
        get {
            return Double(view.frameRotation)
        } set {
            view.frameRotation = CGFloat(newValue)
        }
    }

    public var frameCenterRotation : Double {
        get {
            return Double(view.frameRotation)
        } set {
            view.frameCenterRotation = CGFloat(newValue)
        }
    }
}