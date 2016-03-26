//
//  ViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 3/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func testing(sender: AnyObject) {
        self.performSegueWithIdentifier("testing", sender: sender)
    }
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")

    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    var alertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        // 1
//        
//    }
    
    // Called when the user touches on the main view (outside the UITextField).
    // This causes the keyboard to go away also - but handles all situations when
    // the user touches anywhere outside the keyboard.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UITextFieldDelegate delegate method
    //
    // This method is called when the user touches the Return key on the
    // keyboard. The 'textField' passed in is a pointer to the textField
    // widget the cursor was in at the time they touched the Return key on
    // the keyboard.
    //
    // From the Apple documentation: Asks the delegate if the text field
    // should process the pressing of the return button.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // A responder is an object that can respond to events and handle them.
        // Resigning first responder here means this text field will no longer be the first
        // UI element to receive an event from this apps UI - you can think of it as giving
        // up input 'focus'.
        self.emailTxtField.resignFirstResponder()
        self.passwordTxtField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signupBtn(sender: AnyObject) {
        performSegueWithIdentifier("signup", sender: sender)
    }

    @IBAction func loginBtn(sender: AnyObject) {
        myRootRef.authUser(emailTxtField!.text, password: passwordTxtField.text,
            withCompletionBlock: { (error, auth) in
                if error != nil {
                    print( "inside if " )
                    self.alertController = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                        print("Ok Button Pressed 1");
                    }
                    self.alertController!.addAction(okAction)
                    
                    self.presentViewController(self.alertController!, animated: true, completion:nil)
                    
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                            case .InvalidEmail:
                                //TODO
                                print("Invalid email")
                            case .InvalidPassword:
                                print("Invalid password")
                                //TODO
                            default:
                                //TOOD
                                print("default")
                        }
                    }
                    
                } else {
                    
                    print( "auth = " + String( auth ) )
                    self.performSegueWithIdentifier("completedLogin", sender: sender)
                    
                }
        })
        
        
        

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        return false
    }
    
   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        
        if( segue.identifier == "completeLogin" ) {
            let navVC = segue.destinationViewController as! UINavigationController
            let tableVC = navVC.viewControllers.first as! HomeTableViewController
            //navVC.pushViewController(tableVC, animated: true )
        }
        

    }*/
    
    
}

