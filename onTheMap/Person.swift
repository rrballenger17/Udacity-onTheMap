//
//  UserData.swift
//  onTheMap
//
//  Created by Ryan Ballenger on 6/7/16.
//  Copyright © 2016 Ryan Ballenger. All rights reserved.
//

import Foundation
import UIKit

class Person {
        
        //init(fullName: String, URL: String, latitude: Double, longitude: Double, updateTime: String) {
        init(input: [String:String]) {
            name = input["fullName"]
            url = input["URL"]
            lat = Double(input["latitude"]!)
            long = Double(input["longitude"]!)
            update = input["updateTime"]
        }
        
        var name: String!
        var url: String!
        var lat: Double!
        var long: Double!
        var update: String!

}