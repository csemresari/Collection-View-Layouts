//
//  CategoryPageRectangle.swift
//  Demo
//
//  Created by EMRE SARI on 1/16/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit

class CategoryPageRectangle
{
    var BrandName: String
    var image: UIImage
    var TotalPrice : Float
    var Price : Float
  
    init(BrandName: String, TotalPrice : Float, Price : Float, image: UIImage)
    {
        self.BrandName = BrandName
        self.TotalPrice = TotalPrice
        self.Price = Price
        self.image = image
    }
  
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat
    {
        let rect = NSString(string: BrandName).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(rect.height)
    }
  
}
