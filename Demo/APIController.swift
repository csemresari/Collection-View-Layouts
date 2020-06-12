//
//  APIController.swift
//  Demo
//
//  Created by EMRE SARI on 1/16/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

@objc protocol APIDelegate
{
    optional func didReceiveHomePageRectangles( list : NSMutableArray)
    optional func didReceiveCategoryPageRectangles( list : NSMutableArray, title : String)
    optional func didReceiveProductDetails( product : ProductDetails)
}

class APIController
{
    var delegate : APIDelegate?
    
    func getHomePageItems()-> Void
    {
        let homePageRects = NSMutableArray()
        
        let givenAPILink = "https://gist.githubusercontent.com/cihadhoruzoglu/46058323f1ff584c2979/raw/61c49c009ec4da76798e39fbb3ff1a99e350979a/gistfile1.txt"
        
        let session = NSURLSession.sharedSession()
        let urlString = givenAPILink
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if error == nil
            {
                let json = JSON(data: data!)
                
                for (_,subJson):(String, JSON) in json["Banners"]
                {
                    let urlForImage = NSURL(string:subJson["ImagePath"].stringValue)
                    let dataForImage = NSData(contentsOfURL:urlForImage!)
                    if dataForImage != nil
                    {
                        let Description = subJson["Description"].stringValue
                        let image = UIImage(data: dataForImage!)
                        
                        homePageRects.addObject(HomePageRectangle(Description: Description, image: image!))
                    }
                }
                self.delegate!.didReceiveHomePageRectangles!(homePageRects)
            }
            else
            {
                print("Error: \(error!.localizedDescription)")
            }
        }
        
        dataTask.resume()
        
    }
    
    func getCategoryPageItems(givenAPILink : String)-> Void
    {
        let categoryPageRects = NSMutableArray()
        
        let session = NSURLSession.sharedSession()
        let urlString = givenAPILink
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if error == nil
            {
                let json = JSON(data: data!)
                
                let title = json["Title"].stringValue
                
                for (_,subJson):(String, JSON) in json["Products"]
                {
                    let urlForImage = NSURL(string:subJson["ImageLink"].stringValue)
                    let dataForImage = NSData(contentsOfURL:urlForImage!)
                    if dataForImage != nil
                    {
                        
                        let BrandName = subJson["BrandName"].stringValue
                        let TotalPrice = subJson["TotalPrice"].floatValue
                        let Price = subJson["Price"].floatValue
                        let image = UIImage(data: dataForImage!)
                        
                        categoryPageRects.addObject(CategoryPageRectangle(BrandName: BrandName, TotalPrice: TotalPrice, Price: Price, image: image!))
                    }
                }
                self.delegate?.didReceiveCategoryPageRectangles!(categoryPageRects,title: title)
            }
            else
            {
                print("Error: \(error!.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
    
    func getProductDetails()-> Void
    {
        var product : ProductDetails?

        let givenAPILink = "https://gist.githubusercontent.com/cihadhoruzoglu/8c73bc3f225df777bbf5/raw/7fd9e2b9fdbff3fd0a9445857bd7c8d507644f45/gistfile1.txt"

        let session      = NSURLSession.sharedSession()
        let urlString    = givenAPILink
        let url          = NSURL(string: urlString)
        let request      = NSURLRequest(URL: url!)
        let dataTask     = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if error == nil
            {
                let json = JSON(data: data!)
                
                let BrandName    = json["BrandName"].stringValue
                let ProductName  = json["ProductName"].stringValue
                let Description  = json["Description"].stringValue
                let DeliveryTime = json["DeliveryTime"].stringValue
                let CurrencyText = json["CurrencyText"].stringValue
                let Gender       = json["Gender"].stringValue

                let ProductId    = json["ProductId"].intValue

                let OldPrice     = json["OldPrice"].floatValue
                let Price        = json["Price"].floatValue

                let Images       = NSMutableArray()
                let ModelInfo    = NSMutableArray()
                
                for (_,subJson):(String, JSON) in json["Images"]
                {
                    let urlForImage = NSURL(string : subJson.stringValue)
                    let dataForImage = NSData(contentsOfURL : urlForImage!)
                    
                    if dataForImage != nil
                    {
                        Images.addObject(UIImage(data: dataForImage!)!)
                    }
                }
                
                for (_,subJson):(String, JSON) in json["ModelInfo"]
                {
                    let PKey = subJson["PKey"].stringValue
                    let PValue = subJson["PValue"].stringValue
                    
                    ModelInfo.addObject(Model(PKey: PKey, PValue: PValue))
                }
                
                product = ProductDetails(BrandName: BrandName, ProductName: ProductName, Description: Description, DeliveryTime: DeliveryTime, CurrencyText: CurrencyText, Gender: Gender, Images: Images, ModelInfo: ModelInfo, ProductId: ProductId, OldPrice: OldPrice, Price: Price)
                
                self.delegate?.didReceiveProductDetails!(product!)
            }
            else
            {
                print("Error: \(error!.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
}