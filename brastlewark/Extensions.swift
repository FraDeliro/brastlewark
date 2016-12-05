//
//  Extensions.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import Foundation
import UIKit

//MARK: - UIColor
extension UIColor {
    class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func primaryColor() -> UIColor {
        return self.colorFromRGB(0x2D4452)
    }
    
    class func accentColor() -> UIColor {
        return self.colorFromRGB(0xE67E22)
    }
}

//MARK: - CALayer
extension CALayer {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}

//MARK: - Array
extension Array {
    func contains<T>(_ obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
    mutating func removeObject<T>(_ obj: T) where T : Equatable {
        self = self.filter({$0 as? T != obj})
    }
    
}

//MARK: - UIImage
extension UIImage {
    class func imageWithImage(_ image: UIImage, newSize:CGSize) -> UIImage {
        let ratioW = image.size.width / newSize.width
        let ratioH = image.size.height / newSize.height
        let ratio = image.size.width / image.size.height
        var showSize = CGSize.zero
        
        if (ratioW > 1 && ratioH > 1) {
            
            if (ratioW > ratioH) {
                showSize.width = newSize.width
                showSize.height = showSize.width / ratio
            } else {
                showSize.height = newSize.height;
                showSize.width = showSize.height * ratio
            }
            
        } else if (ratioW > 1) {
            
            showSize.width = newSize.width
            showSize.height = newSize.width / ratio
            
        } else if (ratioH > 1) {
            
            showSize.height = newSize.height
            showSize.width = newSize.height * ratio
            
        } else {
            showSize.width = newSize.width
            showSize.height = newSize.width / ratio
        }
        
        UIGraphicsBeginImageContextWithOptions(showSize, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: showSize.width, height: showSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func cropImage(_ anImage:UIImage) -> UIImage? {
        var cropRegion = CGRect.zero
        if anImage.size.width > anImage.size.height {
            cropRegion = CGRect(x: (anImage.size.width/2.0)-(anImage.size.height/2.0), y: 0, width: anImage.size.height, height: anImage.size.height)
        }
        else if anImage.size.height > anImage.size.width {
            cropRegion = CGRect(x: 0, y: (anImage.size.height/2.0)-(anImage.size.width/2.0), width: anImage.size.width, height: anImage.size.width)
        }
        else {
            cropRegion = CGRect(x: 0, y: 0, width: anImage.size.width, height: anImage.size.height)
        }
        let scale = UIScreen.main.scale
        cropRegion = CGRect(x: cropRegion.origin.x*scale, y: cropRegion.origin.y*scale, width: cropRegion.size.width*scale, height: cropRegion.size.height*scale)
        
        if let subImage = anImage.cgImage!.cropping(to: cropRegion) {
            let croppedImage = UIImage(cgImage: subImage)
            return croppedImage
        }
        return nil
    }
    
}

//MARK: - UIViewController
extension UIViewController {
    private struct MenuImage{
        static var selectedMenuImage: UIImage?
        static var unselectedMenuImage: UIImage?
        static var defaultID: String?
        static var tabTitle: String?
    }
    
    var selectedMenuImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &MenuImage.selectedMenuImage) as? UIImage
        }
        set {
            if let unwrappedValue = newValue {
                
                objc_setAssociatedObject(self, &MenuImage.selectedMenuImage, unwrappedValue as UIImage?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    var unselectedMenuImage: UIImage? {
        
        get {
            return objc_getAssociatedObject(self, &MenuImage.unselectedMenuImage) as? UIImage
        }
        set {
            if let unwrappedValue = newValue {
                
                objc_setAssociatedObject(self, &MenuImage.unselectedMenuImage, unwrappedValue as UIImage?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var defaultID: Int? {
        get {
            return objc_getAssociatedObject(self, &MenuImage.defaultID) as? Int
        }
        set {
            if let unwrappedValue = newValue {
                
                objc_setAssociatedObject(self, &MenuImage.defaultID, unwrappedValue as Int?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var tabTitle: String? {
        get {
            return objc_getAssociatedObject(self, &MenuImage.tabTitle) as? String
        }
        set {
            if let unwrappedValue = newValue {
                
                objc_setAssociatedObject(self, &MenuImage.tabTitle, unwrappedValue as String?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
}

//MARK: - UIView Utility
func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
    return UINib(
        nibName: nibNamed,
        bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? UIView
}
