 //
//  PostViewControllerClass.swift
//  onTheMap
//
//  Created by Ryan Ballenger on 6/4/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class PostViewControllerClass: UIViewController{
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var URLText: UITextField!
    
    @IBOutlet weak var LocationText: UITextField!
    
    var result: CLPlacemark!
    var objectId: String!
    var firstName: String!
    var lastName: String!
    var newURL: String!
    
    func getOldUserInfo(update: Bool){

        // get first and last
        
        let key = (UIApplication.sharedApplication().delegate as! AppDelegate).key
        
        let urlString = "https://www.udacity.com/api/users/" + key
        
        Requests.taskForGETMethod(urlString, parameters: ["sd":"asd"], slide: true) { (parsedResult, error) -> Void in
            
            print(parsedResult)
            
            guard let json = parsedResult["user"] as! [String: AnyObject]! else {
                print("Cannot find results session1")
                return
            }
        
            guard let fName = json["first_name"] as! String! else{
                
                print("Cannot find results session2")
                return
            }
            
            guard let lName = json["last_name"] as! String! else{
                
                print("Cannot find results session2")
                return
            }
            
            self.firstName = fName
            
            self.lastName = lName
            
            self.newURL = self.URLText.text
            
            if(update){
                self.updateInfo()
            }else{
                self.postFirstTimeUser()
            }
    
        }
        
    }
    
    
    func postFirstTimeUser(){
        
        let key = (UIApplication.sharedApplication().delegate as! AppDelegate).key
        let locationName = result.name
        let lat = String(result.location!.coordinate.latitude)
        let long = String(result.location!.coordinate.longitude)
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation"
        
        var bodyString = "{\"uniqueKey\": \"" + key
        bodyString += "\", \"firstName\": \"" + firstName + "\", \"lastName\": \"" + lastName + "\",\"mapString\": \""
        bodyString += locationName! + "\", \"mediaURL\": \"" + newURL +  "\",\"latitude\": "
        bodyString += (lat + ", \"longitude\":" + long + "}")
        
        
        var postData = postStorage()
        postData.urlString = urlString
        postData.jsonBody = bodyString
        postData.lat = lat
        postData.long = long
        
        let newViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("MapViewNewInfo"))! as! MapViewNewInfoController
        
        newViewController.info = postData
        
        newViewController.post = true
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationController!.pushViewController(newViewController, animated: true)
        }
        
    
    }
    
    
    func firstTimeUser(){
        
            self.getOldUserInfo(false)
        
    }
    
    func checkOverwrite(oid:String){
        
        let alert = UIAlertController(title: "Overwrite", message:
            "Update previous location and URL.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            self.objectId = oid
            self.getOldUserInfo(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            dispatch_async(dispatch_get_main_queue()) {
                self.topLabel.text = "Update the following fields."
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    func queryFor(){
        let key = (UIApplication.sharedApplication().delegate as! AppDelegate).key
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22" + key + "%22%7D"
        
        Requests.taskForGETMethod(urlString, parameters: ["sd":"asd"], slide: false) { (parsedResult, error) -> Void in
            
            guard let json = parsedResult["results"] as! [[String: AnyObject]]! else {
                print("Cannot find results session1")
                return
            }
            
            
            // Post location for first time
            if(json.count == 0){
                
                print(json)
                self.objectId = nil
                self.firstTimeUser()
                return
            }
            
            print(json[0])
            
            guard let oid = json[0]["objectId"] as! String! else{
                
                print("Cannot find results session2")
                return
            }
            
            

            dispatch_async(dispatch_get_main_queue()) {
                self.checkOverwrite(oid)

            }
        }
        
    }
    
    func goBack(){
    
            self.navigationController?.popViewControllerAnimated(true)

    }
    
    
    struct postStorage{
        var urlString: String!
        var jsonBody: String!
        var lat: String!
        var long: String!
    }
    
    func updateInfo(){
        
        //print("objectid: " + objectId)
    
        var urlString = "https://api.parse.com/1/classes/StudentLocation"
        
        if(objectId != nil){
            urlString += "/"
            urlString += objectId
        }
       
        let key = (UIApplication.sharedApplication().delegate as! AppDelegate).key
        let locationName = result.name
        let lat = String(result.location!.coordinate.latitude)
        let long = String(result.location!.coordinate.longitude)
        
        var bodyString = "{\"uniqueKey\": \"" + key
        bodyString += "\", \"firstName\": \"" + firstName + "\", \"lastName\": \"" + lastName + "\",\"mapString\": \""
        bodyString += locationName! + "\", \"mediaURL\": \"" + newURL +  "\",\"latitude\": "
        bodyString += (lat + ", \"longitude\":" + long + "}")
        
        print(bodyString)
        print (urlString)
        
        
        var postData = postStorage()
        postData.urlString = urlString
        postData.jsonBody = bodyString
        postData.lat = lat
        postData.long = long
        
        let newViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("MapViewNewInfo"))! as! MapViewNewInfoController
        
        newViewController.info = postData
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationController!.pushViewController(newViewController, animated: true)
        }
        
    }
    
    
    func setVar(output: CLPlacemark){
        
        self.result = output
        
        print(self.result.name)
        
        queryFor()
        
    }
    
    func cannotFindLocation(){
        
        let alert = UIAlertController(title: "Geocode Error", message:
            "The submitted location cannot be found.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            
        }))

        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
            self.topLabel.text = "Please try again."
        }
        
        print("location not found")
        
    }
    
    func geocodeThis(user: String) -> Void{
        let gc = CLGeocoder()
        
        gc.geocodeAddressString(user, completionHandler: { (placemarks, error) in
            if error == nil && placemarks!.count > 0 {
                
                self.setVar(CLPlacemark(placemark: placemarks![0]))
            }else{
                
                self.cannotFindLocation()
                
                print("cannot find location")
                // cannot geocode location
            }
        })
        
    }
    
    override func viewDidLoad() {
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.hidden = true
    
    }
    
    
    
    @IBAction func submitButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.topLabel.text = "Saving..."
        }
        
        geocodeThis(LocationText.text!)
    
    }
    
    

}