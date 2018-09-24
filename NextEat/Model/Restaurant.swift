//
//  Place.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/9/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation



struct Restaurant {
    
    var name: String
    var city: String
    var image: Data?
    var phone: String
    var rating: String
    
    init(name: String, city: String, phone: String, rating: String)
    {
        self.name = name
        self.city = city
        self.phone = phone
        self.rating = rating
    }
    
    init(_ place: Place)
    {
        self.name = place.name!
        self.city = place.city!
        self.phone = place.phone!
        self.rating = place.rating!
    }
    
}
