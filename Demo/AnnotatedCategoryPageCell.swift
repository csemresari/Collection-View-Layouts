//
//  AnnotatedCategoryPageCell.swift
//  Demo
//
//  Created by EMRE SARI on 1/16/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit

class AnnotatedCategoryPageCell: UICollectionViewCell
{
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!

    @IBOutlet weak var labelBrandName: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
  
    var rect: CategoryPageRectangle?
    {
        didSet
        {
            if let rect = rect
            {
                imageView.image = rect.image
                labelBrandName.text = rect.BrandName
                labelPrice.text = String(rect.Price) + " TL"
                labelTotalPrice.text = String(rect.TotalPrice)

                let strikeThroughAttributes = [NSStrikethroughStyleAttributeName : 1]
                let strikeThroughString = NSAttributedString(string: String(rect.TotalPrice) + " TL", attributes: strikeThroughAttributes)
                labelTotalPrice.attributedText = strikeThroughString
            }
        }
    }
  
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes)
    {
        super.applyLayoutAttributes(layoutAttributes)
        
        if let attributes = layoutAttributes as? CategoryPageLayoutAttributes
        {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
