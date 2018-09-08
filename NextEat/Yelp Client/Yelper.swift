//
//  YelpController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/3/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit

class Yelper: NSObject {

    
    private func yelpURLFromParameters(_ parameters: [String: AnyObject]) -> URL
    {
        
        var components = URLComponents()
        components.scheme = Constants.Yelp.APIScheme
        components.host = Constants.Yelp.APIHost
        components.path = Constants.Yelp.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    func searchByPhrase(_ sender: AnyObject, text: UITextField)
    {
    
        if !text.text!.isEmpty
        {
           // photoTitleLabel.text = "Searching..."
            // TODO: Set necessary parameters!
            let methodParameters =
            [
                Constants.YelpParameterKeys.Method: Constants.YelpParameterValues.SearchMethod,
                Constants.YelpParameterKeys.APIKey: Constants.YelpParameterValues.APIKey,
                Constants.YelpParameterKeys.Location: text.text!,
            ]
            placesFromYelpBySearch(methodParameters as [String:AnyObject])
        }
        else
        {
            statusLabel.text = "Phrase Empty."
        }
    }
    
    private func placesFromYelpBySearch(_ methodParameters: [String: AnyObject], _ completionHandler: @escaping (_ success: Bool) -> Void)
    {
        
        let session = URLSession.shared
        let request = URLRequest(url: yelpURLFromParameters(methodParameters))
        request.addValue("Bearer \(Constants.YelpParameterValues.APIKey)", forHTTPHeaderField: "Authorization")
        
        let task =  session.dataTask(with: request)
        {
            (data, response, error) in
            if error == nil
            {
                print(data)
            }
            else
            {
                print(error!.localizedDescription)
            }
            
            func displayError(_ error: String)
            {
                print(error)
                
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else
            {
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else
            {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else
            {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do
            {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            }
            catch
            {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Yelp return an error (stat != ok)? */
            guard let stat = parsedResult[Constants.YelpResponseKeys.Status] as? String, stat == Constants.YelpResponseValues.OKStatus else
            {
                displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let placeList = parsedResult[Constants.YelpResponseKeys.Businesses] as? [String:AnyObject], let placeArray = placeList[Constants.YelpResponseKeys.Name] as? [[String:AnyObject]] else {
                displayError("Cannot find keys '\(Constants.YelpResponseKeys.Businesses)' and '\(Constants.YelpResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            
            // select a random photo
            
            //MARK: Loop to append random photos to collection
            print(placeArray)
         
        }
        task.resume()
        
        print(yelpURLFromParameters(methodParameters))
    }
    

@IBAction func searchByLatLon(_ sender: AnyObject)
{
    
    
    if isTextFieldValid(latitudeTextField, forRange: Constants.Yelp.SearchLatRange) && isTextFieldValid(longitudeTextField, forRange: Constants.Yelp.SearchLonRange)
    {
        photoTitleLabel.text = "Searching..."
        // TODO: Set necessary parameters!
        let methodParameters = [
            Constants.YelpParameterKeys.APIKey: Constants.YelpParameterValues.APIKey,
            Constants.YelpParameterKeys.SafeSearch: Constants.YelpParameterValues.UseSafeSearch,
            Constants.YelpParameterKeys.Extras: Constants.YelpParameterValues.MediumURL,
            Constants.YelpParameterKeys.Format: Constants.YelpParameterValues.ResponseFormat,
            Constants.YelpParameterKeys.NoJSONCallback: Constants.YelpParameterValues.DisableJSONCallback
        ]
        displayImageFromYelpBySearch(methodParameters as [String:AnyObject])
    }
    else {
        photoTitleLabel.text = "Lat should be [-90, 90].\nLon should be [-180, 180]."
    }
}
    
    class func sharedInstance() -> Yelper
    {
        struct Singleton
        {
            static var sharedInstance = Yelper()
        }
        return Singleton.sharedInstance
        
    }
}
