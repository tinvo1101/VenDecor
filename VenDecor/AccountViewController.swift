//
//  AccountViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 3/18/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    // properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    var alertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        self.deleteAccountBtn.layer.cornerRadius = 5
        
        // navigation bar
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        if revealViewController() != nil {
            self.burgerBtn.target = revealViewController()
            self.burgerBtn.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        let myRootRef = Firebase( url: "https://vendecor.firebaseio.com/users/" )
        let uid = myRootRef.authData.uid
        let userAccount = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid )
        
        userAccount.observeEventType(.Value, withBlock: { snapshot in
            if( String(snapshot.value.valueForKey("profilePic")!) != "" ) {
                let decodedData = NSData(base64EncodedString: String(snapshot.value.valueForKey("profilePic")!), options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                self.profileImageView.image = UIImage(data: decodedData!)
            }
            self.usernameLabel.text = snapshot.value.valueForKey( "username" ) as? String
            self.emailLabel.text = snapshot.value.valueForKey( "email" ) as? String
            self.zipLabel.text = snapshot.value.valueForKey( "zipcode" ) as? String
            self.dateJoinedLabel.text = snapshot.value.valueForKey( "datejoined" ) as? String
        })
    }
    
    // Destroy the account along with its posts
    @IBAction func deleteAccountBtn(sender: AnyObject) {
        self.alertController = UIAlertController(title: "Delete Account", message: "This action will delete your account along with all of your posts. Do you want to continue?", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            

            
            // retrieve the postIDs from the user to delete his/her posts
            let uid = self.myRootRef.authData.uid
            let postsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid + "/postIDs/")
            postsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if !(snapshot.value is NSNull) {
                    let postIDsSnap = snapshot.value as! NSDictionary
                    for (_, val) in postIDsSnap {
                        let postsRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(val))
                        postsRef.removeValue()
                    }
                }
            })
        
            // remove user
            dispatch_sync(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                let userRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid)
                print(uid)
                userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    if !(snapshot.value is NSNull) {
                        let email = snapshot.value.valueForKey("email") as! String
                        let password = snapshot.value.valueForKey("password") as! String
                        print(email)
                        print(password)
                        self.myRootRef.removeUser(email, password: password,
                            withCompletionBlock: { error in
                                if error != nil {} else {}
                        })
                    }
                })
                userRef.removeValue()
            }
            self.performSegueWithIdentifier("deleteAccount", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
        self.alertController!.addAction(okAction)
        self.alertController!.addAction(cancelAction)
        self.presentViewController(self.alertController!, animated: true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imageTapped(img : AnyObject) {
        // not implemented
    }

}
