//
//  PostViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 4/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {

    @IBOutlet weak var claimLabel: UILabel!
    // properties
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var postLocation: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var claimBtn: UIButton!
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    var alertController: UIAlertController? = nil
    var postTitleString: String? = nil
    var postPriceString: String? = nil
    var postLocationString: String? = nil
    var imageString: String? = nil
    var postID: String? = nil
    var claimed: Bool? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        if( claimed! ) {
            self.claimLabel.text = "CLAIMED"
        } else {
            self.claimLabel.text = ""
        }
        
        // rounded corner
        self.messageBtn.layer.cornerRadius = 5
        self.claimBtn.layer.cornerRadius = 5
        
        // transfor price label
        postPrice.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        
        self.postPrice.text = self.postPriceString
        self.postLocation.text = self.postLocationString
        let decodedData = NSData(base64EncodedString: self.imageString!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        self.imageView.image = UIImage(data: decodedData!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // message button
    @IBAction func messageBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("postMsg", sender: self)
    }
    
    // claim button
    @IBAction func claimBtn(sender: AnyObject) {
        if( !claimed! ) {
        let postRef = Firebase(url: "https://vendecor.firebaseio.com/posts/" + self.postID!)
        postRef.childByAppendingPath("claimed").setValue(true)
        self.alertController = UIAlertController(title: "Claim Item", message: "Pick up the item within 24 hours. Contact the seller for more details.", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
        }
        self.alertController!.addAction(okAction)
        self.presentViewController(self.alertController!, animated: true, completion:nil)
        } else {
            self.alertController = UIAlertController(title: "Claim Item", message: "Item has already been claimed.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(okAction)
            self.presentViewController(self.alertController!, animated: true, completion:nil)
        }
    }
    
    // cancel button
    @IBAction func cancelBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navVC = segue.destinationViewController as! UINavigationController
        let messageVC = navVC.viewControllers.first as! MessageViewController
        messageVC.postID = self.postID
        messageVC.senderId = myRootRef.authData.uid
        messageVC.senderDisplayName = ""
        //messageVC.myMessagesViewController = self
    }
    
}
