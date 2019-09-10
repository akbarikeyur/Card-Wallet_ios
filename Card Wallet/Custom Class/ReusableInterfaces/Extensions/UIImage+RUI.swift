//
//  UIImage+RUI.swift
//  Cozy Up
//
//  Created by Amisha on 15/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit


extension UIImage {
    
    func imageResize ()-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 1.0
        let sizeChange:CGSize = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    func simpleRemoveBackgroundColor() -> UIImage? {
        let rawImageRef = cgImage
        
        let colorMasking : [CGFloat] = [250, 255, 250, 255, 250, 255]
        
        UIGraphicsBeginImageContext(size)
        let maskedImageRef = rawImageRef?.copy(maskingColorComponents: colorMasking)
        do {
            //if in iphone
            UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: size.height)
            UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        }
        UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        UIGraphicsGetCurrentContext()?.setAllowsAntialiasing(true)
        UIGraphicsGetCurrentContext()?.setShouldAntialias(true)
        let result: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
