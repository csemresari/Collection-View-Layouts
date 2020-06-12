//
//  ProductDetailViewController.swift
//  Demo
//
//  Created by EMRE SARI on 1/10/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProductDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, APIDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var BrandName: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var OldPrice: UILabel!
    @IBOutlet weak var CurrencyText1: UILabel!
    @IBOutlet weak var CurrencyText2: UILabel!
    @IBOutlet weak var labelSegmentTitle: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var galleryScrollViewHeightConstraint: NSLayoutConstraint!
    
    
    var loadingNotification = MBProgressHUD()
    private var pageViewController: UIPageViewController?
    var imageCounts = 0
    var images = NSMutableArray()
    var imageView: UIImageView!
    var theProduct : ProductDetails?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.textView.text = ""
        self.tableView.hidden = true
        
        let api = APIController()
        api.delegate = self
        api.getProductDetails()
        
        self.galleryScrollView.delegate = self

        
        self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Yükleniyor..."
    }
    
    func didReceiveProductDetails(product: ProductDetails)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.theProduct = product
            self.images = product.Images!
            self.imageCounts = product.Images!.count
            self.BrandName.text = product.BrandName
            self.ProductName.text = product.ProductName
            self.navigationItem.title = product.BrandName
            let strikeThroughAttributes = [NSStrikethroughStyleAttributeName : 1]
            let strikeThroughString = NSAttributedString(string: String(product.OldPrice), attributes: strikeThroughAttributes)
            self.OldPrice.attributedText = strikeThroughString
            self.Price.text = String(product.Price)
            self.CurrencyText1.text = product.CurrencyText
            self.CurrencyText2.text = product.CurrencyText
            self.textView.text = product.Description
            
            let firstImage = self.images[0] as! UIImage
            
            self.galleryScrollViewHeightConstraint.constant = self.view.frame.width * firstImage.size.height / firstImage.size.width
            
            self.galleryScrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.width * firstImage.size.height / firstImage.size.width)
            
            let galleryScrollViewWidth:CGFloat = self.view.frame.width
            let galleryScrollViewHeight:CGFloat = self.view.frame.width * firstImage.size.height / firstImage.size.width
            
          
            let imgOne = UIImageView(frame: CGRectMake(0, 0,galleryScrollViewWidth, galleryScrollViewHeight))
            imgOne.image = self.images[0] as? UIImage
            let imgTwo = UIImageView(frame: CGRectMake(galleryScrollViewWidth, 0,galleryScrollViewWidth, galleryScrollViewHeight))
            imgTwo.image = self.images[1] as? UIImage
            let imgThree = UIImageView(frame: CGRectMake(galleryScrollViewWidth*2, 0,galleryScrollViewWidth, galleryScrollViewHeight))
            imgThree.image = self.images[2] as? UIImage
            let imgFour = UIImageView(frame: CGRectMake(galleryScrollViewWidth*3, 0,galleryScrollViewWidth, galleryScrollViewHeight))
            imgFour.image = self.images[3]  as? UIImage
            
            self.galleryScrollView.addSubview(imgOne)
            self.galleryScrollView.addSubview(imgTwo)
            self.galleryScrollView.addSubview(imgThree)
            self.galleryScrollView.addSubview(imgFour)
            
            self.galleryScrollView.contentSize = CGSizeMake(self.galleryScrollView.frame.width * 4, self.galleryScrollView.frame.height)
            
            self.pageControl.currentPage = 0
            self.pageControl.backgroundColor = UIColor.clearColor()
            self.pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
            self.pageControl.currentPageIndicatorTintColor = UIColor(netHex: 0xC12068)
            
            self.segmentedControl.selectedSegmentIndex = 0
            self.labelSegmentTitle.text = self.segmentedControl.titleForSegmentAtIndex(0)
            self.labelSegmentTitle.textColor = UIColor(netHex: 0xC12068)
            self.textView.text = self.theProduct?.Description
            self.textView.hidden = false
        
            MBProgressHUD.hideAllHUDsForView(self.view,animated: true)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth : CGFloat = CGRectGetWidth(galleryScrollView.frame)
        
        let currentPage : CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth ) + 1
        
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        
    }
    
    
    @IBAction func indexChanged(sender: UISegmentedControl)
    {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.labelSegmentTitle.text = self.segmentedControl.titleForSegmentAtIndex(0)
            self.tableView.hidden = true
            self.textView.text = self.theProduct?.Description
            self.textView.hidden = false
            
        case 1:
            self.labelSegmentTitle.text = self.segmentedControl.titleForSegmentAtIndex(1)
            self.tableView.reloadData()
            self.textView.hidden = true
            self.tableView.hidden = false
            
        case 2:
            self.labelSegmentTitle.text = self.segmentedControl.titleForSegmentAtIndex(2)
            self.tableView.hidden = true
            self.textView.text = self.theProduct?.DeliveryTime
            self.textView.hidden = false
        default:
            break;
        }
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if self.imageCounts != 0
        {
            return self.theProduct!.ModelInfo!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let theCell: ModelInfoCell = self.tableView.dequeueReusableCellWithIdentifier("ModelInfoCell", forIndexPath: indexPath ) as! ModelInfoCell;
        
        let model = self.theProduct!.ModelInfo![indexPath.row] as! Model
        
        theCell.PValue.text = model.PValue
        theCell.PKey.text = model.PKey
        
        return theCell;
    }

    
}

