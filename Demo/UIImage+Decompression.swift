//
//  UIImage+Decompression.swift
//  Demo
//
//  Created by EMRE SARI on 1/16/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit

extension UIImage
{
  
  var decompressedImage: UIImage
    {
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    drawAtPoint(CGPointZero)
    let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return decompressedImage
    }
  
}
