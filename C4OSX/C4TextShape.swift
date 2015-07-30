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

import QuartzCore
import Foundation

public class C4TextShape : C4Shape {
    private var text: String = "" {
        didSet {
            updatePath()
        }
    }
    private var font: C4Font {
        didSet {
            updatePath()
        }
    }

    public init() {
        font = C4Font(name: "AvenirNext-DemiBold", size:12)
        super.init(frame: C4Rect(0,0,1,1))
    }
//
//    public override init(frame: C4Rect) {
//        font = C4Font(name: "AvenirNext-DemiBold", size:80)
//        super.init(frame: frame)
//    }

    /**
    Initializes a new C4TextShape from a specifed string and a font

        let f = C4Font(name:"Avenir Next", size: 120)
        let t = C4TextShape(text:"C4", font: f)
        t.center = canvas.center
        canvas.add(t)

    :param: text The string to be rendered as a shape
    :param: font The font used to define the shape of the text
    */
    convenience public init(text: String, font: C4Font) {
        self.init()
        self.text = text
        self.font = font
        lineWidth = 0.0
        fillColor = C4Pink
        updatePath()
        self.origin = C4Point()
    }

    /**
    Initializes a new C4TextShape from a specifed string, using C4's default font.
    
    let t = C4TextShape(text:"C4")
    t.center = canvas.center
    canvas.add(t)
    
    :param: text The string to be rendered as a shape
    */
    convenience public init(text: String) {
        self.init(text:text, font:C4Font(name: "Menlo-Regular", size:4))
        self.text = text
        lineWidth = 0.0
        fillColor = C4Pink
        updatePath()
        self.origin = C4Point()
    }

    override func updatePath() {
        path = C4TextShape.createTextPath(text, font: font)
        adjustToFitPath()
    }

    internal class func createTextPath(text: String, font: C4Font) -> C4Path? {
        let ctfont = font.CTFont
        
        var unichars = [UniChar](text.utf16)
        var glyphs = [CGGlyph](count: unichars.count, repeatedValue: 0)
        if !CTFontGetGlyphsForCharacters(ctfont, &unichars, &glyphs, unichars.count) {
            // Failed to encode characters into glyphs
            return nil
        }

        var advances = [CGSize](count: glyphs.count, repeatedValue: CGSizeZero)
        CTFontGetAdvancesForGlyphs(ctfont, CTFontOrientation.Default, &glyphs, &advances, glyphs.count)
        
        let textPath = CGPathCreateMutable()
        var origin = CGPointZero
        for i in 0..<glyphs.count {
            let glyphPath = CTFontCreatePathForGlyph(ctfont, glyphs[i], nil)
            var translation = CGAffineTransformMakeTranslation(origin.x, origin.y)
            CGPathAddPath(textPath, &translation, glyphPath)
            origin.x += CGFloat(advances[i].width)
            origin.y += CGFloat(advances[i].height)
        }
        
        return C4Path(path: textPath)
    }
}
