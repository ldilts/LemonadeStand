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
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lemonLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    
    
    var lemonadeStand = Stand()
    
    var pageViews: [UIView?] = []
    var pageColors: [UIColor] = []
    
    let lemonYellow = UIColor(red: 247/255.0, green: 220/255.0, blue: 111/255.0, alpha: 1).CGColor
    let StoreYellow = UIColor(red: 247/255.0, green: 225/255.0, blue: 136/255.0, alpha: 1)
    let leafGreen = UIColor(red: 38/255.0, green: 194/255.0, blue: 129/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "Lobster 1.3", size: 24)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.suppliesView.layer.borderWidth = 1
        self.suppliesView.layer.borderColor = self.lemonYellow
        self.suppliesView.layer.cornerRadius = 10
        self.outputTextView.layer.cornerRadius = 10
        self.startButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageViews.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }

        var frame = CGRect(x: self.view.frame.width * CGFloat(page), y: 0.0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)

        let newPageView = UIView()
        newPageView.backgroundColor = pageColors[page]

        //newPageView.contentMode = .ScaleAspectFit
        newPageView.frame = frame
        
        var target = ""
        switch page {
            case 0:
                target = "first"
            case 1:
                target = "second"
            default:
                target = ""
        }
        
        var leftMinusButton = self.makeButton(NSSelectorFromString(target + "LeftMinusButtonTapped:"), frame: CGRectMake(10, newPageView.frame.height/2 - 23, 46, 46), image: "Minus Button")
        var leftPlusButton = self.makeButton(NSSelectorFromString(target + "LeftPlusButtonTapped:"), frame: CGRectMake(leftMinusButton.frame.origin.x + 46 + 50, newPageView.frame.height/2 - 23, 46, 46), image: "Plus Button")
        
        var rightPlusButton = self.makeButton(NSSelectorFromString(target + "RightPlusButtonTapped:"), frame: CGRectMake(self.scrollView.frame.size.width - 46 - 10, newPageView.frame.height/2 - 23, 46, 46), image: "Plus Button")
        var rightMinusButton = self.makeButton(NSSelectorFromString(target + "RightMinusButtonTapped:"), frame: CGRectMake(rightPlusButton.frame.origin.x - 46 - 50, newPageView.frame.height/2 - 23, 46, 46), image: "Minus Button")
        
        var leftTextField = UITextField()
        self.makeTextField(leftTextField, frame: CGRectMake((((leftMinusButton.frame.origin.x + 23) + (leftPlusButton.frame.origin.x + 23))/2) - 20, ((((leftMinusButton.frame.origin.y + 23) + (leftPlusButton.frame.origin.y + 23))/2) - 15), 40, 30))
        
        var rightTextField = UITextField()
        self.makeTextField(rightTextField, frame: CGRectMake((((rightMinusButton.frame.origin.x + 23) + (rightPlusButton.frame.origin.x + 23))/2) - 20, ((((rightMinusButton.frame.origin.y + 23) + (rightPlusButton.frame.origin.y + 23))/2) - 15), 40, 30))
        
        newPageView.addSubview(leftMinusButton)
        newPageView.addSubview(leftPlusButton)
        newPageView.addSubview(rightMinusButton)
        newPageView.addSubview(rightPlusButton)
        newPageView.addSubview(leftTextField)
        newPageView.addSubview(rightTextField)
        scrollView.addSubview(newPageView)
        
        pageViews[page] = newPageView
    }
    
    func makeTextField(textField: UITextField, frame: CGRect) {
        textField.frame = frame
        textField.backgroundColor = UIColor.whiteColor()
        textField.layer.cornerRadius = 5.0
        textField.userInteractionEnabled = false
    }
    
    func makeButton(target: Selector, frame: CGRect, image: String) -> UIButton {
        let image = UIImage(named: image) as UIImage?
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame
        button.setImage(image, forState: .Normal)
        button.tintColor = self.leafGreen
        button.addTarget(self, action: target, forControlEvents:.TouchUpInside)
        
        return button
    }
    
    // Mix View
    func firstLeftMinusButtonTapped(sender:UIButton!) {
        self.lemonadeStand.removeIce()
        printStuff()
    }
    
    func firstLeftPlusButtonTapped(sender:UIButton!) {
        self.lemonadeStand.addIce()
        printStuff()
    }
    
    func firstRightMinusButtonTapped(sender:UIButton!) {
        self.lemonadeStand.removeLemon()
        printStuff()
    }
    
    func firstRightPlusButtonTapped(sender:UIButton!) {
        self.lemonadeStand.addLemon()
        printStuff()
    }
    
    // Shop View
    func secondLeftMinusButtonTapped(sender:UIButton!) {
        self.lemonadeStand.returnIce()
        printStuff()
    }
    
    func secondLeftPlusButtonTapped(sender:UIButton!) {
        self.lemonadeStand.purchaseIce()
        printStuff()
    }
    
    func secondRightMinusButtonTapped(sender:UIButton!) {
        self.lemonadeStand.returnLemon()
        printStuff()
    }
    
    func secondRightPlusButtonTapped(sender:UIButton!) {
        self.lemonadeStand.purchaseLemon()
        printStuff()
    }
    
    // Delete!
    func printStuff() {
        println("Lemons: " + "\(self.lemonadeStand.lemons)")
        println("Ice: " + "\(self.lemonadeStand.ice)")
        println("Balance: " + "\(self.lemonadeStand.balance)")
        println("Lemonade Mix:")
        println("   Lemons: " + "\(self.lemonadeStand.lemonadeMix.lemons)")
        println("   Ice: " + "\(self.lemonadeStand.lemonadeMix.ice)" + "\n\n")
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
//        println("\(self.view.frame.size.width)")
        
//        println("\(self.scrollView.frame.size.width)")
        
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

