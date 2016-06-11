//
//  ViewController.swift
//  onTheMap
//
//  Created by Ryan Ballenger on 6/3/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var key:String!
    var sessionID:String!
    
    func setTheStatus(message: String){
        dispatch_async(dispatch_get_main_queue()) {
            self.theStatusLabel.text = message
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setTheStatus("Hello, please sign in.")
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheStatus("Hello, please sign in.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var theStatusLabel: UILabel!
    
    func segueToTabController(){
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("signInSuccess", sender: self)
        }
    }


    @IBOutlet weak var emailField: UITextField!

    
    @IBOutlet weak var passwordField: UITextField!

    
    func incorrectEntry(){
        
        let alert = UIAlertController(title: "Error", message:
            "Username and/or password not found.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            
        }))
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
            self.setTheStatus("Please try again.")
        }
        
    }
    
    
    func badConnection(){
        
        let alert = UIAlertController(title: "Connection Error", message:
            "Please check your internet access.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            
        }))
     
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
            self.setTheStatus("Connection error. Please try again.")
        }
        
    }
    
    
    @IBAction func signIn(sender: AnyObject) {
        
        self.setTheStatus("Loading...")
        
        let body = "{\"udacity\": {\"username\": \"" + emailField.text! + "\", \"password\": \"" + passwordField.text! + "\"}}"
        
        var parameters = [String: String]()
        parameters["application/json"] = "Accept"
        parameters["application/json"] = "Content-Type"
        
        
        Requests.taskForPOSTMethod("https://www.udacity.com/api/session", parameters: parameters, jsonBody: body) { (parsedResult, error) -> Void in
            
            if(error != nil){
                self.badConnection()
                return
            }
            
            guard let sessionJson = parsedResult["session"] as? [String: AnyObject] else {
                
                self.incorrectEntry()
                
                print("Cannot find json session")
                return
            }
            
            
            
            guard let sID = sessionJson["id"] as? String else {
                print("Cannot get id from session in json")
                return
            }
            
            print(sID)
            self.sessionID = sID
            
            guard let accountJson = parsedResult["account"] as? [String: AnyObject] else {
                print("Cannot find json account")
                return
            }
            
            guard let keyLocal = accountJson["key"] as? String else {
                print("Cannot get key in json")
                return
            }
            
            
            self.key = keyLocal
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).key = keyLocal
            
            print(keyLocal)
            
            self.segueToTabController()
            
        }
    }

}

