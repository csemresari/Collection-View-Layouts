//
//  CategoryViewController.swift
//  Demo
//
//  Created by EMRE SARI on 1/16/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD

class CategoryViewController: UICollectionViewController , APIDelegate
{
    var loadingNotification = MBProgressHUD()
    var rects = NSMutableArray()
    
    var itemIndex = Int()
    var givenAPILink = String()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        self.collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        
        let api = APIController()
        api.delegate = self
        
        api.getCategoryPageItems(self.givenAPILink)
        
        self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Yükleniyor..."
    }
 
    
    func didReceiveCategoryPageRectangles(list: NSMutableArray, title : String)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            if(self.itemIndex == 0)
            {
                self.parentViewController!.parentViewController!.navigationItem.title = title
            }
            
            self.rects = list
            
            if let layout = self.collectionView?.collectionViewLayout as? CategoryPageLayout
            {
                layout.delegate = self
            }

            self.collectionView!.contentInset = UIEdgeInsets(top: 64, left: 5, bottom: 10, right: 5)
        
            MBProgressHUD.hideAllHUDsForView(self.view,animated: true)
            self.collectionView?.reloadData()
        }
    }
}

extension CategoryViewController
{
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return rects.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedCategoryPageCell", forIndexPath: indexPath) as! AnnotatedCategoryPageCell
        cell.rect = rects[indexPath.item] as? CategoryPageRectangle
        return cell
    }
}

extension CategoryViewController : CategoryPageLayoutDelegate
{
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat
    {
        let categoryPageRectangle = rects[indexPath.item] as! CategoryPageRectangle
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRectWithAspectRatioInsideRect(categoryPageRectangle.image.size, boundingRect)
        return rect.size.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    {
        let annotationPadding      = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)

        let categoryPageRectangle  = rects[indexPath.item] as! CategoryPageRectangle
        let font                   = UIFont(name: "AvenirNext-Regular", size: 12)!
        let commentHeight          = categoryPageRectangle.heightForComment(font, width: width)
        let height                 = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
}
