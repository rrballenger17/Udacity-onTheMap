//
//  Requests.swift
//  onTheMap
//
//  Created by Ryan Ballenger on 6/6/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import Foundation


class Requests{
    
        static private func convertDataWithCompletionHandler(newData: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        let parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            print("Could not parse the data as JSON: '\(newData)'")
            return
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
        
    }
    
    static func test(one: String){
        
    }
    
    static func taskForPOSTMethod(method: String, parameters: [String:String], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.HTTPMethod = "POST"
        
        for (one, two) in parameters{
            request.addValue(one, forHTTPHeaderField: two)
        }
        
        let body = jsonBody
        
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                
                print("first error/ bad connection error")
                
                completionHandlerForPOST(result: nil, error: NSError(domain: "badConnection", code: 200, userInfo: nil))
                
                return
           
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        task.resume()
        return task
    }
    
    
    static func taskForPUTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let url = NSURL(string: method)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForPUT(result: nil, error: error)
                return
            }
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            completionHandlerForPUT(result: data, error: error)
            
        }
        
        task.resume()
        return task
    }
    
    
    
    static func taskForGETMethod(method: String, parameters: [String:AnyObject], slide: Bool, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        print(method)
        
        let request = NSMutableURLRequest(URL: NSURL(string: method)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                
                completionHandlerForGET(result: nil, error: error)
                
                return
            }
            
            let theData = slide ? data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) : data
            
           
            convertDataWithCompletionHandler(theData!, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        task.resume()
        return task
    }
    
    
    

    
    
    static func logOutMethod(completionHandlerForLogOut: () -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            completionHandlerForLogOut()
        }
        task.resume()
       
    }

    

}
