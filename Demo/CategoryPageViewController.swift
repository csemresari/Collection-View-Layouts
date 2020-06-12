//
//  CategoryPageViewController.swift
//  Demo
//
//  Created by EMRE SARI on 1/10/16.
//  Copyright © 2016 EMRE SARI. All rights reserved.
//

import UIKit
import MBProgressHUD

class CategoryPageViewController: UIViewController, UIPageViewControllerDataSource
{
    
    private var pageViewController: UIPageViewController?
    
    var loadingNotification = MBProgressHUD()
    
    let givenAPILink1 = "https://gist.githubusercontent.com/cihadhoruzoglu/07a5d45054506ae2f08f/raw/415ad508b530c00496d7a9c08a70403572e03c9d/gistfile1.txt"
    
    let givenAPILink2 = "https://gist.githubusercontent.com/cihadhoruzoglu/dbfa67cce5f82537be41/raw/2f451d8449c6058637dd9b2f67d190cdefa4cdb7/gistfile1.txt"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Yükleniyor..."
        
        createPageViewController()
        setupPageControl()
    }
    
    private func createPageViewController()
    {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        let firstController = getCategoryViewController(0, givenAPILink: self.givenAPILink1)!
        let startingViewControllers: NSArray = [firstController]
        pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
        self.navigationItem.title = firstController.title
    }
    
    private func getCategoryViewController(itemIndex: Int, givenAPILink : String) -> CategoryViewController?
    {
        let categoryViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CategoryViewController") as! CategoryViewController
        categoryViewController.itemIndex = itemIndex
        categoryViewController.givenAPILink = givenAPILink
        return categoryViewController
    }
    
    private func setupPageControl()
    {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGrayColor()
        appearance.currentPageIndicatorTintColor = UIColor(netHex: 0xC12068)
        appearance.backgroundColor = UIColor.clearColor()
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let categoryViewController = viewController as! CategoryViewController
        
        if categoryViewController.itemIndex == 1
        {
            return getCategoryViewController(0 , givenAPILink: self.givenAPILink1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        
        let categoryViewController = viewController as! CategoryViewController
        
        if categoryViewController.itemIndex  == 0
        {
            return getCategoryViewController(1, givenAPILink: self.givenAPILink2)
        }
        
        return nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}
