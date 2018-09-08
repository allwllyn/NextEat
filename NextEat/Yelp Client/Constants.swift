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
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: Yelp Parameter Keys
    struct YelpParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let SortBy = "sort_by"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let location = "location"
        static let BoundingBox = "bbox"
        static let Page = "page"
    }
    
    // MARK: Yelp Parameter Values
    struct YelpParameterValues {
       // static let SearchMethod = "https://api.yelp.com/v3/businesses/search"
        static let APIKey = "WWkGUJ8sJsZlpcZg01n9XKQK11VS2GTXegY34UJIuf3GTk5tjBbu_VAFTAanQ3Tbkf79BUjp14Bib9XrpWoVQParSTORPj7XbBB4zFZgosYL7ucrCBjzJGqxK7yNW3Yx"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
       // static let GalleryPhotosMethod = //get something from yelp
        static let Sorter = "rating"
        static let MediumURL = "url_m"
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
    }
    
    // MARK: Yelp Response Values
    struct YelpResponseValues {
        static let OKStatus = "ok"
    }
    
    // FIX: As of Swift 2.2, using strings for selectors has been deprecated. Instead, #selector(methodName) should be used.
    /*
     // MARK: Selectors
     struct Selectors {
     static let KeyboardWillShow: Selector = "keyboardWillShow:"
     static let KeyboardWillHide: Selector = "keyboardWillHide:"
     static let KeyboardDidShow: Selector = "keyboardDidShow:"
     static let KeyboardDidHide: Selector = "keyboardDidHide:"
     }
     */
}
