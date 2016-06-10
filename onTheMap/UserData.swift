//
//  UserData.swift
//  onTheMap
//
//  Created by Ryan Ballenger on 6/7/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import Foundation
import UIKit

class UserData: UIViewController {
    
    struct person {
        
        init(fullName: String, URL: String, latitude: Double, longitude: Double, updateTime: String) {
            name = fullName
            url = URL
            lat = latitude
            long = longitude
            update = updateTime
        }
        
        var name: String!
        var url: String!
        var lat: Double!
        var long: Double!
        var update: String!
    }
    
    static var persons: [person]!
    

    static func getPersonData(results: [[String: AnyObject]], completionHandlerForUserData: (success: Bool) -> Void){
        self.persons = [person]()
        
        for index in 0...results.count-1{
            print(index)
            
            guard let laPersona = results[index] as? [String: AnyObject] else {
                print("Cannot find person")
                return
            }
            
            guard let firstName = laPersona["firstName"] as? String else {
                print("Cannot find person")
                return
            }
            
            guard let lastName = laPersona["lastName"] as? String else {
                print("Cannot find person")
                return
            }
            
            guard let mediaURL = laPersona["mediaURL"] as? String else {
                print("Cannot find person")
                return
            }
            
            guard let lat = laPersona["latitude"] as? Double else {
                print("Cannot find lat")
                return
            }
            
            guard let long = laPersona["longitude"] as? Double else {
                print("Cannot find long")
                return
            }
            
            
            
            var update = laPersona["updatedAt"]
            
            if(update!.error != nil){
                update = laPersona["createdAt"]
                print("got created")
            }
        
            
            let store = person(fullName: firstName + " " + lastName, URL: mediaURL, latitude: lat, longitude: long, updateTime: String(update!))
            
            self.persons.append(store)
            
            print("size" + String(self.persons.count))
            
            print(store.lat)
            
        }

        
        self.persons = self.persons.sort { $0.update.compare($1.update) == .OrderedDescending }
        
        
        for p in self.persons{
            print(p.update)
            
        }
        
        completionHandlerForUserData(success: true)
        
    }
    

    
    static func connectionError(sender: AnyObject){
        
        let alert = UIAlertController(title: "Connection Error", message:
            "Please check your internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            
        }))
        
        dispatch_async(dispatch_get_main_queue()) {
            sender.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    static func getUserData(sender: AnyObject, completionHandlerForUserData: (success: Bool) -> Void) {
        
        Requests.taskForGETMethod("https://api.parse.com/1/classes/StudentLocation?limit=100", parameters: ["sd":"asd"], slide: false) { (parsedResult, error) -> Void in
            
            
            if(parsedResult == nil || error != nil){
                print("bad user connection")
                
                self.connectionError(sender)
                
                completionHandlerForUserData(success: false)
                
                return

            }
            
            
            guard let results = parsedResult["results"] as? [[String: AnyObject]] else {
                print("Cannot find results session")
                return
            }
            
            print("it's working")
            
            self.getPersonData(results, completionHandlerForUserData: completionHandlerForUserData)
        }
    
        
    }

}