//
//  Icon.swift
//  FontAwesomeKit.Swift
//
//  Created by Ethan Yang on 15/6/23.
//  Copyright © 2015年 Ethan Yang. All rights reserved.
//

import Foundation
import CoreText
public class Icon{
    var mutableAttributedString: NSMutableAttributedString
    public var drawingBackgroundColor: UIColor? = nil
    public var drawingPositionAdjustment: UIOffset = UIOffsetZero
    
    init(mutableAttributedString: NSMutableAttributedString){
        self.mutableAttributedString = mutableAttributedString;
    }
    
    public class func icons(icon: IconProtocol, _ icons: IconProtocol ...)(size: CGFloat)(color: UIColor?) ->Icon{
        let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: icon.iconName, attributes: [NSFontAttributeName: icon.iconFontWithSize(size), NSForegroundColorAttributeName: color ?? UIColor.blackColor()]))
        
        for icon in icons {
            mutableAttributedString.appendAttributedString(NSAttributedString(string: icon.iconName, attributes: [NSFontAttributeName: icon.iconFontWithSize(size), NSForegroundColorAttributeName: color ?? UIColor.blackColor()]))
        }
        return Icon(mutableAttributedString: mutableAttributedString)
    }
    
    public func append(icon: IconProtocol)(size: CGFloat)(color: UIColor?) {
        let attributedString = NSAttributedString(string: icon.iconName, attributes: [NSFontAttributeName: icon.iconFontWithSize(size), NSForegroundColorAttributeName: color ?? UIColor.blackColor()])
        mutableAttributedString.appendAttributedString(attributedString)
    }
    public func append(icon: Icon){
        mutableAttributedString.appendAttributedString(icon.attributedString)
    }
    
    public var attributedString: NSAttributedString{
        return NSAttributedString(attributedString: mutableAttributedString)
    }
    var characterCode: String{
        return mutableAttributedString.string
    }
    var iconFontSize: CGFloat{
        get{
            return iconFont.pointSize
        }
        set{
            addAttribute(name: NSFontAttributeName, value: iconFont.fontWithSize(newValue))
        }
    }
    // MARK: - Setting and Getting Attributes
    public func setAttributes(var attrs: [String: AnyObject]){
        if attrs[NSFontAttributeName] == nil {
            attrs[NSFontAttributeName] = iconFont
        }
        mutableAttributedString.setAttributes(attrs, range: rangeForMutableAttributedText)
    }
    public func addAttribute(name name:String, value: AnyObject){
        mutableAttributedString.addAttribute(name, value: value, range: rangeForMutableAttributedText)
    }
    public func addAttributes(attrs: [String: AnyObject]){
        mutableAttributedString.addAttributes(attrs, range: rangeForMutableAttributedText)
    }
    public func removeAttribute(name name: String){
        mutableAttributedString.removeAttribute(name, range: rangeForMutableAttributedText)
    }
    public var attributes: [String: AnyObject]{
        return mutableAttributedString.attributesAtIndex(0, effectiveRange: nil)
    }
    public func attribute(attrName attrName: String) ->AnyObject?{
        return mutableAttributedString.attribute(attrName, atIndex: 0, effectiveRange: nil)
    }
    var rangeForMutableAttributedText: NSRange{
        return NSMakeRange(0, mutableAttributedString.length)
    }
    
    public var iconFont: UIFont{
        return attribute(NSFontAttributeName) as! UIFont
    }
    
    public func attribute(attrName: String) ->AnyObject{
        return mutableAttributedString.attribute(attrName, atIndex: 0, effectiveRange: nil)!
    }
    //MARK: - Image Drawing
    public func imageWithSize(imageSize: CGSize) ->UIImage{
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0);
        
        func fillBackgroundForContext(context: CGContextRef, backgroundSize size: CGSize){
            if let backgroundColor = self.drawingBackgroundColor {
                backgroundColor.setFill()
                CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
            }
        }
        func drawingRectWithImageSize(imageSize: CGSize) ->CGRect{
            let iconSize = mutableAttributedString.size()
            var xOffset = (imageSize.width - iconSize.width) / 2.0
            xOffset += drawingPositionAdjustment.horizontal;
            var yOffset = (imageSize.height - iconSize.height) / 2.0;
            yOffset += drawingPositionAdjustment.vertical;
            return CGRectMake(xOffset, yOffset, iconSize.width, iconSize.height);
        }
        
        // ---------- begin context ----------
        let context = UIGraphicsGetCurrentContext();
        fillBackgroundForContext(context, backgroundSize: imageSize)
        mutableAttributedString.drawInRect(drawingRectWithImageSize(imageSize))
        let iconImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // ---------- end context ----------
        UIGraphicsEndImageContext();
        
        return iconImage;
    }
}
public protocol IconProtocol{
    func iconFontWithSize(size: CGFloat)->UIFont
    var iconName: String{
        get
    }
}
extension UIFont{
    private class func registerIconFont(URL URL: NSURL){
        let path = URL.path
        assert(path != nil,"Wrong file path!")
        assert(NSFileManager.defaultManager().fileExistsAtPath(path!),"Font file doesn't exist at \(path!)")
        let fontDataProvider = CGDataProviderCreateWithURL(URL)
        let newFont = CGFontCreateWithDataProvider(fontDataProvider)
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(newFont!, &error) {
            let errorDescription: CFStringRef = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSInternalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }
}
private func registerFont(resourceName: String, withExtension: String){
    let bundle = NSBundle(forClass: Icon.self)
    let url: NSURL = bundle.URLForResource(resourceName, withExtension: withExtension)!
    UIFont.registerIconFont(URL: url)
}
private let assertNotNil:(obj: AnyObject?)->() = {
    obj in
    assert(obj != nil, "Font should not be nil, check if the font file is added to the application bundle and you're using the correct font name.")
}

extension FontAwesome: IconProtocol{
    public func iconFontWithSize(size: CGFloat)->UIFont{
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken, {
            registerFont("FontAwesome", withExtension: "otf")
        })
        let font = UIFont(name: "FontAwesome", size: size)
        assertNotNil(obj: font)
        
        return font!
    }
    public var iconName: String{
        return self.rawValue.substringToIndex(advance(self.rawValue.startIndex, 1))
    }
}

extension Zocial: IconProtocol{
    public func iconFontWithSize(size: CGFloat)->UIFont{
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken, {
            registerFont("zocial-regular-webfont", withExtension: "ttf")
        })
        let font = UIFont(name: "Zocial", size: size)
        assertNotNil(obj: font)
        
        return font!
    }
    public var iconName: String{
        return self.rawValue.substringToIndex(advance(self.rawValue.startIndex, 1))
    }
}
extension FoundationIcons: IconProtocol{
    public func iconFontWithSize(size: CGFloat)->UIFont{
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken, {
            registerFont("foundation-icons", withExtension: "ttf")
        })
        let font = UIFont(name: "fontcustom", size: size)
        assertNotNil(obj: font)
        
        return font!
    }
    public var iconName: String{
        return self.rawValue.substringToIndex(advance(self.rawValue.startIndex, 1))
    }
}
extension IonIcons: IconProtocol{
    public func iconFontWithSize(size: CGFloat)->UIFont{
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken, {
            registerFont("ionicons", withExtension: "ttf")
        })
        let font = UIFont(name: "Ionicons", size: size)
        assertNotNil(obj: font)
        
        return font!
    }
    public var iconName: String{
        return self.rawValue.substringToIndex(advance(self.rawValue.startIndex, 1))
    }
}