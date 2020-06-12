//
//  ProductDetails.swift
//  Demo
//
//  Created by EMRE SARI on 1/16/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit

class ProductDetails : NSObject
{
    var BrandName:     String
    var ProductName:   String
    var Description:   String
    var DeliveryTime:  String
    var CurrencyText : String
    var Gender :       String
    var ProductId:     Int
    var OldPrice :     Float
    var Price :        Float
    var Images:        NSMutableArray?
    var ModelInfo:     NSMutableArray?
    
    init
    (
        BrandName: String,
        ProductName: String,
        Description: String,
        DeliveryTime: String,
        CurrencyText: String,
        Gender: String,
        Images: NSMutableArray,
        ModelInfo: NSMutableArray,
        ProductId: Int,
        OldPrice : Float,
        Price : Float
    )
    {
        self.BrandName    = BrandName
        self.ProductName  = ProductName
        self.Description  = Description
        self.DeliveryTime = DeliveryTime
        self.CurrencyText = CurrencyText
        self.Gender       = Gender
        self.Images       = Images
        self.ModelInfo    = ModelInfo
        self.ProductId    = ProductId
        self.OldPrice     = OldPrice
        self.Price        = Price
    }
}
