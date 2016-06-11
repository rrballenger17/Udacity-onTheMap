

//
//  ViewController.swift
//  onTheMap
//
//  Created by Ryan Ballenger on 6/3/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
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
        
            print("viewForAnnotation")
        
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
            if pinView == nil {
                
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                pinView!.canShowCallout = true
                
                pinView!.animatesDrop = false
                
                let button = dynamicButton(type: UIButtonType.DetailDisclosure)
                
                button.destination = annotation.subtitle!
                
                button.addTarget(self, action: "linkTo:", forControlEvents: .TouchUpInside)
                
                pinView!.rightCalloutAccessoryView = button
             
            }else {
                pinView!.annotation = annotation
            }
            
            return pinView!
    
    }

    
    func plotData(){
        for index in 0...UserData.persons.count - 1{
            
            let persona = UserData.persons[index]
            
            let coordinate = CLLocationCoordinate2D(
                latitude: persona.lat,
                longitude: persona.long
            )
            
            let point = MKPointAnnotation()
            point.coordinate = coordinate
            point.title = persona.name
            point.subtitle = persona.url
            mapView.addAnnotation(point)
            
        }
        
    }
   

    func reloadTheData(){
        (self.navigationController as! NavigationCustomControllerMap).refreshButton.enabled = false
        
        viewDidAppear(false)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    func enableRefreshButton(){
        (self.navigationController as! NavigationCustomControllerMap).refreshButton.enabled = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.hidden = false

        mapView.delegate = self
        
        let pins = self.mapView.annotations
        
        if pins.count != 0 {
            for pin in pins {
                mapView.removeAnnotation(pin)
            }
        }

        UserDataMethods.getUserData(self){ (success: Bool) -> Void in
            
            if(success){
                dispatch_async(dispatch_get_main_queue()) {
                    let initialPoint =  CLLocation(latitude: 39.05, longitude: -94.34)
                    let radius: CLLocationDistance = 3000000
                    let region = MKCoordinateRegionMakeWithDistance(initialPoint.coordinate,
                        radius * 2.0, radius * 2.0)
                    self.mapView.setRegion(region, animated: false)
            
                    print("plotData")
            
                    self.plotData()
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.enableRefreshButton()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}