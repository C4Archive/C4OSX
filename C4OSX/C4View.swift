// Copyright © 2014 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import AppKit

public class C4View : NSObject {
    public var view : NSView = NSView()
    
    public override init() {
    }
    
    /**
    Initializes a new C4View from a NSView.
    
    - parameter view: A NSView.
    */
    public init(view: NSView) {
        self.view = view;
        view.wantsLayer = true
    }
    
    /**
    Initializes a new C4View with the specifed frame.
    
        let f = C4Rect(0,0,100,100)
        let v = C4View(frame: f)
        canvas.add(v)
    
    - parameter frame: A C4Rect, which describes the view’s location and size in its superview’s coordinate system.
    */
    convenience public init(frame: C4Rect) {
        self.init()
        self.view.frame = CGRect(frame)
    }
    
    /**
    Returns the receiver's layer.
    */
    public var layer: CALayer? {
        get {
            return view.layer
        }
    }
    
    /**
    Returns the receiver's frame. Animatable.
    */
    public var frame: C4Rect {
        get {
            return C4Rect(view.frame)
        }
        set {
            view.frame = CGRect(newValue)
        }
    }
    
    /**
    Returns the receiver's bounds. Animatable.
    */
    public var bounds: C4Rect {
        get {
            return C4Rect(view.bounds)
        }
        set {
            view.bounds = CGRect(newValue)
        }
    }
    
    /**
    Returns the receiver's center point. Animatable.
    */
    public var center: C4Point {
        get {
            return view.center
        }
        set(val) {
            frame = C4Rect(val, size)
        }
    }

    /**
    Returns the receiver's origin. Animatable.
    */
    public var origin: C4Point {
        get {
            return frame.origin
        }
        set {
            frame = C4Rect(newValue, self.size)
        }
    }
    
    /**
    Returns the receiver's frame size. Animatable.
    */
    public var size: C4Size {
        get {
            return bounds.size
        }
        set {
            bounds = C4Rect(origin, newValue)
        }
    }
    
    /**
    Returns the receiver's frame width. Animatable.
    */
    public var width: Double {
        get {
            return Double(bounds.size.width)
        }
    }
    
    /**
    Returns the receiver's frame height. Animatable.
    */
   public var height: Double {
        get {
            return Double(bounds.size.height)
        }
    }
 
    /**
    Returns the receiver's background color. Animatable.
    */
    public var backgroundColor: C4Color? {
        get {
            if let color = view.layer?.backgroundColor {
                return C4Color(color)
            } else {
                return nil
            }
        }
        set {
            if let color = newValue {
                view.layer?.backgroundColor = color.CGColor
            } else {
                view.layer?.backgroundColor = nil
            }
        }
    }
    
    /**
    Returns the receiver's opacity. Animatable.
    */
    public var opacity: Double {
        get {
            return Double(view.alphaValue)
        }
        set {
            view.alphaValue = CGFloat(newValue)
        }
    }
    
    /**
    Returns true if the receiver is hidden, false if visible.
    */
    public var hidden: Bool {
        get {
            return view.hidden
        }
        set {
            view.hidden = newValue
        }
    }
    
    /**
    Returns the receiver's current transform.
    */
    public var transform: C4Transform {
        get {
            return C4Transform((view.layer?.transform)!)
        }
        set {
            view.layer?.transform = newValue.transform3D
        }
    }

    /** 
    Defines the anchor point of the layer's bounds rect, as a point in
    normalized layer coordinates - '(0, 0)' is the bottom left corner of
    the bounds rect, '(1, 1)' is the top right corner. Defaults to
    '(0.5, 0.5)', i.e. the center of the bounds rect. Animatable. 
    */
    public var anchorPoint: C4Point {
        get {
            return C4Point((view.layer?.anchorPoint)!)
        }
        set(val) {
            let oldFrame = view.frame
            view.layer?.anchorPoint = CGPoint(val)
            view.frame = oldFrame
        }
    }

    //MARK: - Touchable
    /**
    Returns true if the receiver accepts touch events.
    */
    public var interactionEnabled: Bool = true
    
    public func hitTest(aPoint: NSPoint) -> NSView? {
        if interactionEnabled {
            return view.hitTest(aPoint)
        }
        return nil
    }
    
    //MARK: - AddRemoveSubview
    /**
    Adds a view to the end of the receiver’s list of subviews.
    
    When working with C4, use this method to add views because it handles the addition of both NSView and C4View.

        let v = C4View(frame: C4Rect(0,0,100,100))
        let subv = C4View(frame: C4Rect(25,25,50,50))
        v.add(subv)

    - parameter view:	The view to be added.
    */
    public func add<T>(subview: T) {
        if let v = subview as? NSView {
            view.addSubview(v)
        }
        else if let v = subview as? C4View {
            view.addSubview(v.view)
        }
    }

    /**
    Unlinks the view from the receiver and its window, and removes it from the responder chain.
    
    Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing.

    When working with C4, use this method to add views because it handles the removal of both NSView and C4View.

        let v = C4View(frame: C4Rect(0,0,100,100))
        let subv = C4View(frame: C4Rect(25,25,50,50))
        v.add(subv)
        v.remove(subv)

    - parameter view:	The view to be removed.
    */
    public func remove<T>(subview: T) {
        if let v = subview as? NSView {
            v.removeFromSuperview()
        }
        else if let v = subview as? C4View {
            v.view.removeFromSuperview()
        }
    }
    
    /**
    Unlinks the view from its superview and its window, and removes it from the responder chain.
    
    If the view’s superview is not nil, the superview releases the view.

    Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing.
    
        let v = C4View(frame: C4Rect(0,0,100,100))
        let subv = C4View(frame: C4Rect(25,25,50,50))
        v.add(subv)
        subv.removeFromSuperview()

    */
    public func removeFromSuperview() {
        self.view.removeFromSuperview()
    }

    /**
    Moves the specified subview so that it appears behind its siblings.

    - parameter view: The subview to move to the back.
    */
    public func sendToBack<T>(subview:T) {
        if let v = subview as? NSView {
            view.sendToBack(v)
        } else if let v = subview as? C4View {
            view.sendToBack(v.view)
        }
    }

    /**
    Moves the specified subview so that it appears on top of its siblings.
    
    - parameter view: The subview to move to the front.
    */
    public func bringToFront<T>(subview:T) {
        if let v = subview as? NSView {
            view.bringToFront(v)
        } else if let v = subview as? C4View {
            view.bringToFront(v.view)
        }
    }
    
    //MARK: - HitTest
    
    /**
    Checks if a specified point falls within the bounds of the current object.
    
    :NOTE:
    Because each view has its own coordinates, if you want to check if a point from anywhere on screen falls within a specific view you should use `hitTest(point, from: canvas)`.

        let v = C4View(frame: C4Rect(0,0,100,100))
        v.hitTest(C4Point(50,50)) //-> true
        v.hitTest(C4Point(50, 101)) //-> false

    - parameter point: A `C4Point` to examine

    - returns: `true` if the point is within the object's frame, otherwise `false`.
    */
    public func hitTest(point: C4Point) -> Bool {
        return CGRectContainsPoint(CGRect(bounds), CGPoint(point))
    }

    /**
    Checks if a specified point, from another view, falls within the frame of the receiver.

        let v = C4View(frame: C4Rect(0,0,100,100))
        canvas.add(v)

        canvas.addTapGestureRecognizer() { location, state in
            if v.hitTest(location, from: self.canvas) {
                println("C4")
            }
        }

    - returns: `true` if the point is within the object's frame, otherwise `false`.
    */
    public func hitTest(point: C4Point, from: C4View) -> Bool {
        let p = convert(point, from:from)
        return hitTest(p)
    }

    /**
    Converts a specified point from a given view's coordinate system to that of the receiver.
    
        let p = C4Point()
        let cp = aView.convert(p, from:canvas)

    - returns: A `C4Point` whose values have been translated into the receiver's coordinate system.
    */
    //MARK: – Convert
    public func convert(point: C4Point, from: C4View) -> C4Point {
        return C4Point(view.convertPoint(CGPoint(point), fromView: from.view))
    }

}

/**
Extension to NSView that adds handling addition and removal of C4View objects.
*/
extension NSView {
    /**
    Adds a view to the end of the receiver’s list of subviews.
    
    When working with C4, use this method to add views because it handles the addition of both NSView and C4View.
    - parameter view:	The view to be added.
    */
    public func add<T>(subview: T) {
        if let v = subview as? NSView {
            self.addSubview(v)
        } else if let v = subview as? C4View {
            self.addSubview(v.view)
        }
    }
    
    /**
    Unlinks the view from the receiver and its window, and removes it from the responder chain.
    
    Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing.
    
    When working with C4, use this method to remove views because it handles the removal of both NSView and C4View.
    
    - parameter view:	The view to be removed.
    */
    public func remove<T>(subview: T) {
        if let v = subview as? NSView {
            v.removeFromSuperview()
        } else if let v = subview as? C4View {
            v.view.removeFromSuperview()
        }
    }

    /**
    Moves the specified subview so that it appears behind its siblings.

    When working with C4, use this method because it handles both NSView and C4View.

    - parameter view: The subview to move to the back.
    */
    public func sendToBack<T>(subview:T) {
        if let v = subview as? NSView {
            self.sendToBack(v)
        } else if let v = subview as? C4View {
            self.sendToBack(v.view)
        }
    }

    /**
    Moves the specified subview so that it appears on top of its siblings.

    When working with C4, use this method because it handles both NSView and C4View.

    - parameter view: The subview to move to the front.
    */
    public func bringToFront<T>(subview:T) {
        if let v = subview as? NSView {
            self.bringToFront(v)
        } else if let v = subview as? C4View {
            self.bringToFront(v.view)
        }
    }
}

extension NSView {
    public var center : C4Point {
        get {
            return C4Point(Double(NSMidX(frame)), Double(NSMidY(frame)))
        }
    }
}
