//
//  TableViewController.swift
//  Meme Me
//
//  Created by Ryan Ballenger on 5/23/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{
    
    
    let cellReuseIdentifier = "MyCellReuseIdentifier"
    
    // Add the two essential table data source methods here
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UserData.persons == nil {
            return 0
        }
        
        return UserData.persons.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier)! as UITableViewCell
        
        let persona = UserData.persons[indexPath.row]
        
        cell.textLabel?.text = persona.name
        
        cell.detailTextLabel?.text = persona.url
        
        return cell
    }
    
    func linkTo(url: String) {

        UIApplication.sharedApplication().openURL(NSURL(string: url)!)

    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
       let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let theURL = cell?.detailTextLabel!
        
        linkTo(theURL!.text!)
        
    }
    

    @IBOutlet weak var navItemTwo: UINavigationItem!
    
    
    func move(){
        
    }
    
    
    func reloadTheData(){
        
        (self.navigationController as! NavigationCustomController).refreshButton.enabled = false
        
        viewDidAppear(false)
        
        print("reloaded it!")
    }
    
    func enableRefreshButton(){
        (self.navigationController as! NavigationCustomController).refreshButton.enabled = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.hidden = false


        UserData.getUserData(self) { (success: Bool) -> Void in
            
            if(success){
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                (self.navigationController as! NavigationCustomController).refreshButton.enabled = true
            }
        }

    }
    
    
}




