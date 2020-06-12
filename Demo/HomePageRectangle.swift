//
//  HomePageRectangle.swift
//  Demo
//
//  Created by EMRE SARI on 1/16/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit

class HomePageRectangle
{
    var Description: String
    var image:       UIImage

    init(Description: String, image: UIImage)
    {
        self.Description = Description
        self.image = image
    }

    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat
    {
        let rect = NSString(string: Description).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(rect.height)
    }
  
}
