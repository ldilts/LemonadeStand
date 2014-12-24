//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Lucas Michael Dilts on 12/5/14.
//  Copyright (c) 2014 Lucas Dilts. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var suppliesView: UIView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lemonLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    
    var mixIceTextField = UITextField()
    var mixLemonTextField = UITextField()
    var shopIceTextField = UITextField()
    var shopLemonTextField = UITextField()
    
    var outputString: String = ""
//    var lemonadeStand = Stand()
    var lemonadeStandGame = Game()
    
    var glassUp = AVAudioPlayer()
    var glassDown = AVAudioPlayer()
    var classicBeep = AVAudioPlayer()
    
    var pageViews: [UIView?] = []
    var pageColors: [UIColor] = []
    
    let lemonYellow = UIColor(red: 247/255.0, green: 220/255.0, blue: 111/255.0, alpha: 1).CGColor
    let StoreYellow = UIColor(red: 247/255.0, green: 225/255.0, blue: 136/255.0, alpha: 1)
    let leafGreen = UIColor(red: 38/255.0, green: 194/255.0, blue: 129/255.0, alpha: 1)
    let negativeRed = UIColor(red: 216/255.0, green: 86/255.0, blue: 55/255.0, alpha: 1)
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        //1
        var path = NSBundle.mainBundle().pathForResource(file, ofType:type)
        var url = NSURL.fileURLWithPath(path!)
        
        //2
        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        //4
        return audioPlayer!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.glassUp = self.setupAudioPlayerWithFile("Glass Up", type:"wav")
        self.glassDown = self.setupAudioPlayerWithFile("Glass Down", type:"wav")
        self.classicBeep = self.setupAudioPlayerWithFile("Classic Beep", type:"wav")
        
        var attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "Lobster 1.3", size: 26)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
//        self.suppliesView.layer.borderWidth = 1
//        self.suppliesView.layer.borderColor = self.lemonYellow
        self.suppliesView.layer.cornerRadius = 10
        self.outputTextView.layer.cornerRadius = 10
        self.startButton.layer.cornerRadius = 10
        
        updateView()
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
        updateView()
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
        var title = ""
        switch page {
            case 0:
                target = "first"
                title = "Mix"
            case 1:
                target = "second"
                title = "Shop"
            default:
                target = ""
        }
        
        var titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        titleLabel.frame = CGRectMake(10, 5, 50, 30)
        
        var leftMinusButton = self.makeButton(NSSelectorFromString(target + "LeftMinusButtonTapped:"), frame: CGRectMake(10, newPageView.frame.height/2 - 23, 46, 46), image: "Minus Button")
        var leftPlusButton = self.makeButton(NSSelectorFromString(target + "LeftPlusButtonTapped:"), frame: CGRectMake(leftMinusButton.frame.origin.x + 46 + 50, newPageView.frame.height/2 - 23, 46, 46), image: "Plus Button")
        
        var rightPlusButton = self.makeButton(NSSelectorFromString(target + "RightPlusButtonTapped:"), frame: CGRectMake(self.scrollView.frame.size.width - 46 - 10, newPageView.frame.height/2 - 23, 46, 46), image: "Plus Button")
        var rightMinusButton = self.makeButton(NSSelectorFromString(target + "RightMinusButtonTapped:"), frame: CGRectMake(rightPlusButton.frame.origin.x - 46 - 50, newPageView.frame.height/2 - 23, 46, 46), image: "Minus Button")
        
        var leftTextField = UITextField()
        self.makeTextField(leftTextField, frame: CGRectMake((((leftMinusButton.frame.origin.x + 23) + (leftPlusButton.frame.origin.x + 23))/2) - 20, ((((leftMinusButton.frame.origin.y + 23) + (leftPlusButton.frame.origin.y + 23))/2) - 15), 40, 30))
        
        var rightTextField = UITextField()
        self.makeTextField(rightTextField, frame: CGRectMake((((rightMinusButton.frame.origin.x + 23) + (rightPlusButton.frame.origin.x + 23))/2) - 20, ((((rightMinusButton.frame.origin.y + 23) + (rightPlusButton.frame.origin.y + 23))/2) - 15), 40, 30))
        
//        var leftIconImageView = UIImageView()
//        leftIconImageView.frame = CGRectMake((leftTextField.frame.origin.x + (leftTextField.frame.width/2)) - 50 - 11.5, leftTextField.frame.origin.y + leftTextField.frame.height + 5, 23, 23)
//        leftIconImageView.image = UIImage(named: "snowflake")
        
        var leftLabel = UILabel()
        leftLabel.text = "Ice"
        leftLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        leftLabel.textAlignment = .Center
        leftLabel.frame = CGRectMake((leftTextField.frame.origin.x + (leftTextField.frame.width/2)) - 50, leftTextField.frame.origin.y + leftTextField.frame.height + 5, 100, 25)
        
//        var rightIconImageView = UIImageView()
//        rightIconImageView.frame = CGRectMake(0, 0, 23, 23)
//        rightIconImageView.image = UIImage(named: "LemonIcon")
        
        var rightLabel = UILabel()
        rightLabel.text = "Lemon"
        rightLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        rightLabel.textAlignment = .Center
        rightLabel.frame = CGRectMake((rightTextField.frame.origin.x + (rightTextField.frame.width/2)) - 50, rightTextField.frame.origin.y + rightTextField.frame.height + 5, 100, 25)
        
        switch page {
            case 0:
                self.mixIceTextField = leftTextField
                self.mixLemonTextField = rightTextField
            case 1:
                self.shopIceTextField = leftTextField
                self.shopLemonTextField = rightTextField
            default:
                self.mixIceTextField = leftTextField
                self.mixLemonTextField = rightTextField
        }
        
        newPageView.addSubview(leftMinusButton)
        newPageView.addSubview(leftPlusButton)
        newPageView.addSubview(rightMinusButton)
        newPageView.addSubview(rightPlusButton)
        newPageView.addSubview(leftTextField)
        newPageView.addSubview(rightTextField)
        newPageView.addSubview(leftLabel)
        newPageView.addSubview(rightLabel)
        newPageView.addSubview(titleLabel)
//        newPageView.addSubview(leftIconImageView)
//        newPageView.addSubview(rightIconImageView)
        scrollView.addSubview(newPageView)
        
        pageViews[page] = newPageView
    }
    
    func makeTextField(textField: UITextField, frame: CGRect) {
        textField.frame = frame
        textField.backgroundColor = UIColor.whiteColor()
        textField.layer.cornerRadius = 5.0
        textField.textAlignment = .Center
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
//        self.classicBeep.play()
        self.lemonadeStandGame.lemonadeStand.removeIce()
        updateView()
//        printStuff()
    }
    
    func firstLeftPlusButtonTapped(sender:UIButton!) {
//        self.classicBeep.play()
        self.lemonadeStandGame.lemonadeStand.addIce()
        updateView()
//        printStuff()
    }
    
    func firstRightMinusButtonTapped(sender:UIButton!) {
//        self.classicBeep.play()
        self.lemonadeStandGame.lemonadeStand.removeLemon()
        updateView()
//        printStuff()
    }
    
    func firstRightPlusButtonTapped(sender:UIButton!) {
//        self.classicBeep.play()
        self.lemonadeStandGame.lemonadeStand.addLemon()
        updateView()
//        printStuff()
    }
    
    // Shop View
    func secondLeftMinusButtonTapped(sender:UIButton!) {
//        self.classicBeep.play()
        self.lemonadeStandGame.lemonadeStand.returnIce()
        updateView()
//        printStuff()
    }
    
    func secondLeftPlusButtonTapped(sender:UIButton!) {
//        self.classicBeep.play()
        self.lemonadeStandGame.lemonadeStand.purchaseIce()
        updateView()
//        printStuff()
    }
    
    func secondRightMinusButtonTapped(sender:UIButton!) {
//        self.classicBeep.play()
        self.lemonadeStandGame.lemonadeStand.returnLemon()
        updateView()
//        printStuff()
    }
    
    func secondRightPlusButtonTapped(sender:UIButton!) {
//        self.classicBeep.play()
        self.lemonadeStandGame.lemonadeStand.purchaseLemon()
        updateView()
//        printStuff()
    }
    
    @IBAction func startDayButtonTapped(sender: AnyObject) {
//        var alert = UIAlertController()
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
//                // What happens when the user taps 'Ok'? That goes in here
//            }))
//        self.presentViewController(alert, animated: true, completion: nil)
        
        if self.lemonadeStandGame.lemonadeStand.lemonadeMix.ice <= 0 {
            self.makeAlertView("ice")
        } else {
            if self.lemonadeStandGame.lemonadeStand.lemonadeMix.lemons <= 0 {
                self.makeAlertView("lemon")
            } else {
                self.lemonadeStandGame.startDay()
                self.outputString += "\(self.lemonadeStandGame.customers.count)" + " customers visited the lemonade stand today.\n" + "\(self.lemonadeStandGame.payingCustomers)" + " of those customers purchased some lemonade.\n\n"
                
                // Check if game over
                if (self.lemonadeStandGame.lemonadeStand.lemons == 0 || self.lemonadeStandGame.lemonadeStand.ice == 0) {
                    if !self.lemonadeStandGame.lemonadeStand.isBalance() {
                        self.outputString += "Not enough money to buy more supplies! Game over! :(\n\n"
                        self.glassDown.play()
                        self.lemonadeStandGame = Game()
                    } else {
                        self.glassUp.play()
                    }
                } else {
                    self.glassUp.play()
                }
                self.updateView()
            }
        }
        
        
        
        
    }
    
    func makeAlertView(item: String) {
        var alert = UIAlertController(title: "Don't forget the " + item + "!", message: "Add " + item + " to your lemonade mix before you start your day.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = self.leafGreen
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateView() {
        if !self.lemonadeStandGame.lemonadeStand.isBalance() {
            balanceLabel.textColor = self.negativeRed
        } else {
            balanceLabel.textColor = self.leafGreen
        }
        
        self.balanceLabel.text = "$" + "\(self.lemonadeStandGame.lemonadeStand.balance)"
        self.iceLabel.text = "x " + "\(self.lemonadeStandGame.lemonadeStand.ice)"
        self.lemonLabel.text = "x " + "\(self.lemonadeStandGame.lemonadeStand.lemons)"
        
        self.mixIceTextField.text = "\(self.lemonadeStandGame.lemonadeStand.lemonadeMix.ice)"
        self.mixLemonTextField.text = "\(self.lemonadeStandGame.lemonadeStand.lemonadeMix.lemons)"
        self.shopIceTextField.text = "\(self.lemonadeStandGame.lemonadeStand.ice)"
        self.shopLemonTextField.text = "\(self.lemonadeStandGame.lemonadeStand.lemons)"
        
        self.outputTextView.text = self.outputString
        
        // scroll to the bottom
        var range = NSMakeRange(countElements(self.outputTextView.text) - 1, 0)
        self.outputTextView.scrollRangeToVisible(range)
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

