//
//  HomeViewController.swift
//  Demo
//
//  Created by EMRE SARI on 1/16/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class HomeViewController: UICollectionViewController , APIDelegate
{
    var loadingNotification = MBProgressHUD()
    var rects = NSMutableArray()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Ana Sayfa"
        let navbarFont = UIFont(name: "HelveticaNeue-Light", size: 18) ?? UIFont.systemFontOfSize(17)
        let barbuttonFont = UIFont(name: "HelveticaNeue-Light", size: 14) ?? UIFont.systemFontOfSize(15)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName: UIColor(netHex: 0x2D2D2D)]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: barbuttonFont], forState: UIControlState.Normal)
    
        
        self.collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        
        let api = APIController()
        api.delegate = self
        api.getHomePageItems()
        
        self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Yükleniyor..."
    }
    
    func didReceiveHomePageRectangles(list: NSMutableArray)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.rects = list
            
            if let layout = self.collectionView?.collectionViewLayout as? HomePageLayout
            {
                layout.delegate = self
            }

            self.collectionView!.contentInset = UIEdgeInsets(top: 64, left: 5, bottom: 10, right: 5)
            
            self.collectionView?.reloadData()
        
                MBProgressHUD.hideAllHUDsForView(self.view,animated: true)
        }
    }
    
}

extension HomeViewController
{
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return rects.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedHomePageCell", forIndexPath: indexPath) as! AnnotatedHomePageCell
        cell.rect = rects[indexPath.item] as? HomePageRectangle
        return cell
    }
}

extension HomeViewController : HomePageLayoutDelegate
{
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat
    {
        let homePageRectangle = rects[indexPath.item] as! HomePageRectangle
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRectWithAspectRatioInsideRect(homePageRectangle.image.size, boundingRect)
        return rect.size.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        
        let homePageRectangle = rects[indexPath.item] as! HomePageRectangle
        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        let commentHeight = homePageRectangle.heightForComment(font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        return height
    }
}
