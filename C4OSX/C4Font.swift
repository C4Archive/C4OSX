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
import CoreText

public class C4Font : NSObject {
    internal var internalFont: NSFont?
    
    /**
    The NSFont representation of the receiver.
    
        let uif = font.NSFont
    */
    public var nsfont : NSFont {
        get {
            return internalFont!;
        }
    }
    
    /**
    Initializes a new C4Font using the specified font name and size.
    
        let f = C4Font("Helvetica", 20)
    */
    convenience public init(name: String, size: Double) {
        self.init()
        internalFont = NSFont(name: name, size: CGFloat(size))
    }
    
    /**
    Initializes a new C4Font using the specified font name and default size of 12.0 pt.

        let f = C4Font("Helvetica")
    */
    convenience public init(name: String) {
        self.init(name: name, size: 12.0)
    }

    /**
    Initializes a new C4Font using a specified NSFont.

        if let uif = NSFont(name: "Helvetica", size: 24) {
            let f = C4Font(font: uif)
        }
    */
    convenience public init(font: NSFont) {
        self.init()
        internalFont = font
    }
    
    /**
    Returns the font object used for standard interface items in the specified size.
    
        let f = C4Font.systemFont(20)

    :param: fontSize	The size (in points) to which the font is scaled.
    :returns:	A font object of the specified size.
    */
    class func systemFont(size: Double) -> C4Font {
        return C4Font(font: NSFont.systemFontOfSize(CGFloat(size)))
    }
    /**
    Returns the font object used for standard interface items that are rendered in boldface type in the specified size.

        let f = C4Font.boldSystemFont(20)

    :param: fontSize	The size (in points) to which the font is scaled.
    :returns:	A font object of the specified size.
    */
    class func boldSystemFont(size: Double) -> C4Font {
        return C4Font(font: NSFont.boldSystemFontOfSize(CGFloat(size)))
    }
    
    /**
    Returns a font object that is the same as the receiver but which has the specified size instead.
    
        let f = C4Font(name: "Avenir Next")
        let f2 = f.font(20)

    :param: fontSize	The desired size (in points) of the new font object.
    :returns:	A font object of the specified size.
    */
    public func font(size: Double) -> C4Font {
        return C4Font(font: NSFont(name: internalFont!.fontName, size: CGFloat(size))!)
    }
    
    /**
    The font family name. (read-only)
    A family name is a name such as Times New Roman that identifies one or more specific fonts. The value in this property is intended for an application’s internal usage only and should not be displayed.
    */
    public var familyName : String {
        get {
            return internalFont!.familyName!
        }
    }
    
    /**
    The font face name. (read-only)
    The font name is a name such as HelveticaBold that incorporates the family name and any specific style information for the font. The value in this property is intended for an application’s internal usage only and should not be displayed.

        let f = C4Font(name: "Avenir Next")
        let n = f.fontName
    */
    public var fontName : String {
        get {
            return internalFont!.fontName
        }
    }
    
    /**
    The receiver’s point size, or the effective vertical point size for a font with a nonstandard matrix. (read-only)
    */
    public var pointSize : Double {
        get {
            return Double(internalFont!.pointSize)
        }
    }
    
    /**
    The top y-coordinate, offset from the baseline, of the receiver’s longest ascender. (read-only)
    The ascender value is measured in points.
    */
    public var ascender : Double {
        get {
            return Double(internalFont!.ascender)
        }
    }
    
    /**
    The bottom y-coordinate, offset from the baseline, of the receiver’s longest descender. (read-only)
    The descender value is measured in points. This value may be positive or negative. For example, if the longest descender extends 2 points below the baseline, this method returns -2.0 .
    */
    public var descender : Double {
        get {
            return Double(internalFont!.descender)
        }
    }
    
    /**
    The receiver’s cap height information. (read-only)
    This value measures (in points) the height of a capital character.
    */
    public var capHeight : Double {
        get {
            return Double(internalFont!.capHeight)
        }
    }
    
    /**
    The x-height of the receiver. (read-only)
    This value measures (in points) the height of the lowercase character "x".
    */
    public var xHeight : Double {
        get {
            return Double(internalFont!.xHeight)
        }
    }
    
    /**
    Returns the standard font size used for labels.
    :returns:	The standard label font size in points.
    */
    public var labelFontSize : Double {
        get {
            return Double(NSFont.labelFontSize())
        }
    }

    /**
    Returns the size of the standard system font.
    :returns:	The standard system font size in points.
    */
    public var systemFontSize : Double {
        get {
            return Double(NSFont.systemFontSize())
        }
    }

    /**
    Returns the size of the standard small system font.
    :returns:	The standard small system font size in points.
    */
    public var smallSystemFontSize : Double {
        get {
            return Double(NSFont.smallSystemFontSize())
        }
    }
    
    /**
    Returns a CGFontRef version of the receiver.
    */
    public var CGFont : CGFontRef {
        get {
            return CGFontCreateWithFontName(fontName as NSString)!
        }
    }
    
    /**
    Returns a CTFontRef version of the receiver.
    */
    public var CTFont : CTFontRef {
        get {
            return CTFontCreateWithNameAndOptions(fontName as CFString, CGFloat(pointSize), nil, CTFontOptions.Default)
        }
    }
}