//
//  MapViewNewInfoController.swift
//  onTheMap
//
//  Created by Ryan Ballenger on 6/7/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MapViewNewInfoController: UIViewController, MKMapViewDelegate {
    
    var post: Bool = false
    
    @IBAction func confirmed(sender: AnyObject) {
        
        if(post){
            
            var parameters = [String: String]()
            parameters["QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"] = "X-Parse-Application-Id"
            parameters["QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"] = "X-Parse-REST-API-Key"
            parameters["application/json"] = "Content-Type"
            
            Requests.taskForPOSTMethod(info.urlString, parameters: parameters, jsonBody: info.jsonBody) { (parsedResult, error) -> Void in
            
                print("possibly success")
                self.popTwoViews()
            }
            
        }else{
        
            Requests.taskForPUTMethod(info.urlString, parameters: ["sd":"asd"], jsonBody: info.jsonBody) { (parsedResult, error) -> Void in
                
                if(error != nil){
                    self.newLocationError()
                    print("putting error")
                    return
                }
                
                print("success for update location put!")
        
                self.popTwoViews()
            }
        }
    }
    
    
    func popTwoViews(){
        let pres = self.presentingViewController
        
        dispatch_async(dispatch_get_main_queue()) {
            pres!.dismissViewControllerAnimated(false, completion: {
                pres!.dismissViewControllerAnimated(false, completion: nil)
            })
        }
    }
    
    
    func newLocationError(){
        let alert = UIAlertController(title: "Error", message:
            "Please check your internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            self.popTwoViews()
            
        }))
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    

    var info: PostViewControllerClass.postStorage!
    
    func linkTo(button: dynamicButton) {
        
        let whereTo = button.destination
        
        if let url = NSURL(string: whereTo) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    class dynamicButton: UIButton {
        
        var destination: String!
        
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        //print("viewForAnnotation")
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            
            pinView!.animatesDrop = true
            
            let button = dynamicButton(type: UIButtonType.DetailDisclosure)
            
            button.destination = annotation.subtitle!
            
            button.addTarget(self, action: "linkTo:", forControlEvents: .TouchUpInside)
            
            pinView!.rightCalloutAccessoryView = button
            
        }else {
            pinView!.annotation = annotation
        }
        
        return pinView!
        
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func plotData(){
        
            
        let coordinate = CLLocationCoordinate2D(
            latitude: Double(info.lat)!,
            longitude: Double(info.long)!
        )
            
        let point = MKPointAnnotation()
        point.coordinate = coordinate
        mapView.addAnnotation(point)
        
        let initialPoint =  CLLocation(latitude: Double(info.lat)!, longitude: Double(info.long)!)
        let radius: CLLocationDistance = 30000
        let region = MKCoordinateRegionMakeWithDistance(initialPoint.coordinate,
            radius * 2.0, radius * 2.0)
        
        
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    
        let initialPoint =  CLLocation(latitude: 39.05, longitude: -94.34)
        let radius: CLLocationDistance = 3000000
        let region = MKCoordinateRegionMakeWithDistance(initialPoint.coordinate,
                    radius * 2.0, radius * 2.0)
        
        
        self.mapView.setRegion(region, animated: false)
        
        self.plotData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
}