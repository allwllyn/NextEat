//
//  Constants.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/3/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation

import UIKit

// MARK: - Constants

struct Constants {
    
    // MARK: Flickr
    struct Yelp {
        static let APIScheme = "https"
        static let APIHost = "api.yelp.com"
        static let APIPath = "/v3/businesses/search"
        
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: Yelp Parameter Keys
    struct YelpParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let SortBy = "sort_by"
        static let Limit = "limit"
        static let Term = "term"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Location = "location"
        static let Page = "page"
        static let Category = "categories"
    }
    
    // MARK: Yelp Parameter Values
    struct YelpParameterValues {
       // static let SearchMethod = "https://api.yelp.com/v3/businesses/search"
        static let APIKey = "WWkGUJ8sJsZlpcZg01n9XKQK11VS2GTXegY34UJIuf3GTk5tjBbu_VAFTAanQ3Tbkf79BUjp14Bib9XrpWoVQParSTORPj7XbBB4zFZgosYL7ucrCBjzJGqxK7yNW3Yx"
        static let ResponseFormat = "json"
        static let LimitAmount = "10"
        static let Sorter = "rating"
        static let Category = "restaurants"
    }
    
    // MARK: Yelp Response Keys
    struct YelpResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Businesses = "businesses"
        static let Photo = "photo"
        static let Title = "title"
        static let Name = "name"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
        static let Rating = "rating"
    }
    
    // MARK: Yelp Response Values
    struct YelpResponseValues {
        static let OKStatus = "ok"
    }
    
}
