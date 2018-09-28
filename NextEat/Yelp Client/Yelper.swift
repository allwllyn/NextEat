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
    
    var cityArray: [String] = []
    var placeArray: [Restaurant] = []
    var filteredArray: [Restaurant] = []
    var dataController: DataController!
    
    
    private func yelpURLFromParameters(_ parameters: [String: AnyObject]) -> URL
    {
        
        var components = URLComponents()
        components.scheme = Constants.Yelp.APIScheme
        components.host = Constants.Yelp.APIHost
        components.path = Constants.Yelp.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters
        {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    func searchByPhrase(cityText: String, termText: String, _ completion: @escaping (_ success: Bool) -> Void)
    {
        
        if !cityText.isEmpty
        {
            
            // TODO: Set necessary parameters!
            let methodParameters =
                [
                    Constants.YelpParameterKeys.Location: cityText,
                    Constants.YelpParameterKeys.Term: termText,
                    Constants.YelpParameterKeys.SortBy: Constants.YelpParameterValues.Sorter,
                    Constants.YelpParameterKeys.Limit: Constants.YelpParameterValues.LimitAmount, Constants.YelpParameterKeys.Category: Constants.YelpParameterValues.Category
            ]
            placesFromYelpBySearch(methodParameters as [String:AnyObject])
            {
                success in
                if success
                {
                    print("succesful!")
                    completion(true)
                }
                else
                {
                    completion(false)
                }
            }
        }
        else
        {
            //statusLabel.text = "Phrase Empty."
            print("phrase empty")
        }
    }
    
    func searchNearby(latitude: String, longitude: String, text: String, _ completion: @escaping (_ success: Bool) -> Void)
    {
        
        
        // TODO: Set necessary parameters!
        let methodParameters =
            [
                Constants.YelpParameterKeys.Term: text,
                Constants.YelpParameterKeys.Latitude: latitude,
                Constants.YelpParameterKeys.Longitude: longitude,
                Constants.YelpParameterKeys.SortBy: Constants.YelpParameterValues.Sorter,
                Constants.YelpParameterKeys.Limit: Constants.YelpParameterValues.LimitAmount, Constants.YelpParameterKeys.Category: Constants.YelpParameterValues.Category
        ]
        placesFromYelpBySearch(methodParameters as [String:AnyObject])
        {
            success in
            if success
            {
                completion(true)
                print("succesful!")
            }
            else
            {
                completion(false)
            }
        }
    }
    
    private func placesFromYelpBySearch(_ methodParameters: [String: AnyObject], _ completion: @escaping (_ success: Bool) -> Void)
    {
        
        let session = URLSession.shared
        var request = URLRequest(url: yelpURLFromParameters(methodParameters))
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
                completion(false)
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
            
            print(parsedResult)
            
            
            /* GUARD: Is the "businesses" key in our result? */
            guard let placeList = parsedResult[Constants.YelpResponseKeys.Businesses] as? [[String:AnyObject]] else {
                displayError("Cannot find keys '\(Constants.YelpResponseKeys.Businesses)' in \(parsedResult)")
                return
            }
            
            //MARK: Check if the place array contains any items
            if placeList.count != 0
            {
                for i in placeList
                {
                    
                    let location = i["location"] as! [String:AnyObject]
                    //  let cityName = location["city"] as! String
                    
                    
                    let name = (i["name"] as! String)
                    let city = (location["city"] as! String)
                    let phone = (i["phone"] as! String)
                    let rating = (i["rating"] as! Double)
                    
                    var placeRestaurant = Restaurant(name: name, city: city, phone: phone, rating: rating.description)
                    
                    var binary: Data
                    let imageURL = URL(string: i["image_url"] as! String)
                    if let imageData = try? Data(contentsOf: imageURL!)
                    {
                        let image = UIImage(data: imageData)
                        let imageBinary = UIImageJPEGRepresentation(image! , 1)
                        binary = imageBinary!
                        placeRestaurant.image = binary
                    }
                    
                    self.placeArray.append(placeRestaurant)
                }
                if self.placeArray.count > 0
                {
                    completion(true)
                }
                print(self.placeArray)
            }
            
        }
        task.resume()
        
        print(yelpURLFromParameters(methodParameters))
    }
    
    //MARK: Create Singleton
    class func sharedInstance() -> Yelper
    {
        struct Singleton
        {
            static var sharedInstance = Yelper()
        }
        return Singleton.sharedInstance
        
    } 
}
