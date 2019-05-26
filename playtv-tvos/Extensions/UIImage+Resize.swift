//
//  UIImage+Resize.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 02.05.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(to newImageSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newImageSize else { return self }
        
        let widthRatio  = newImageSize.width  / self.size.width
        let heightRatio = newImageSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: self.size.width * heightRatio, height: self.size.height * heightRatio)
        } else {
            newSize = CGSize(width: self.size.width * widthRatio, height: self.size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
