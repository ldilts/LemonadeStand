//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Lucas Michael Dilts on 12/5/14.
//  Copyright (c) 2014 Lucas Dilts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var suppliesView: UIView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    var pageViews: [UIView?] = []
    var pageColors: [UIColor] = []
    
    let lemonYellow = UIColor(red: 247/255.0, green: 220/255.0, blue: 111/255.0, alpha: 1).CGColor
    let StoreYellow = UIColor(red: 247/255.0, green: 225/255.0, blue: 136/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "Lobster 1.3", size: 24)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        pageColors = [self.StoreYellow,
            self.StoreYellow]

        pageControl.currentPage = 0
        pageControl.numberOfPages = 2

        for _ in 0..<2 {
            pageViews.append(nil)
        }

        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: self.view.frame.width * 2.0,
            height: pagesScrollViewSize.height)

        loadVisiblePages()
        
        
        self.suppliesView.layer.borderWidth = 1
        self.suppliesView.layer.borderColor = self.lemonYellow
        self.suppliesView.layer.cornerRadius = 10
        self.outputTextView.layer.cornerRadius = 10
        self.startButton.layer.cornerRadius = 10
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageViews.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }

        var frame = CGRect(x: self.view.frame.width * CGFloat(page), y: 0.0, width: self.view.frame.width, height: self.scrollView.frame.height)

        let newPageView = UIView()
        newPageView.backgroundColor = pageColors[page]
        //newPageView.contentMode = .ScaleAspectFit
        newPageView.frame = frame
        
        var minusButton = self.makeButton()
//        var plusButton = self.makeButton()
        newPageView.addSubview(minusButton)
//        newPageView.addSubview(plusButton)
        
        scrollView.addSubview(newPageView)
        
        pageViews[page] = newPageView
    }
    
    func makeButton() -> UIButton {
        let image = UIImage(named: "Minus Button") as UIImage?
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 0, 45, 45)
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: "buttonTouched:", forControlEvents:.TouchUpInside)
        
        return button
    }
    
    func buttonTouched(sender:UIButton!)
    {
        println("Hello")
    }

    func loadVisiblePages() {
        // Load pages in our range
        for index in 0...pageViews.count-1 {
            loadPage(index)
        }
    }
    
    func updatePageControl() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Load the pages that are now on screen
        updatePageControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

