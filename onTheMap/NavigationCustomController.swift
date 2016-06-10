//
//  NavigationCustomController.swift
//  onTheMap
//
//  Created by Ryan Ballenger on 6/4/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import Foundation
import UIKit


class NavigationCustomController: UINavigationController{

    @IBOutlet weak var navBar: UINavigationBar!
    
    
    
    func move(){
        
        let newViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("PostViewController"))! as! PostViewControllerClass
    
        self.pushViewController(newViewController, animated: true)
        
    }
    
    
    func refresh(){
        
       (self.viewControllers[0] as! TableViewController).reloadTheData()
    }
    
    
    func logOutCalled(){
        
        Requests.logOutMethod(){ () -> Void in
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).key = nil
            
            dispatch_async(dispatch_get_main_queue()) {
                let firstView = self.storyboard?.instantiateInitialViewController()
                self.presentViewController(firstView!, animated: false, completion: nil)
            }
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("appear")
    }
    
    
    var refreshButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let post = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "move")
    
        refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
    
        let navItem = UINavigationItem(title: "title")
    
        navItem.setLeftBarButtonItems([post, refreshButton], animated: false)
    
        let logOut = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logOutCalled")
    
        navItem.setRightBarButtonItem(logOut, animated: false)

        navItem.title = ""
    
        navBar.pushNavigationItem(navItem, animated: false)
  
    }
}