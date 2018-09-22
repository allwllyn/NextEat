//
//  CityListViewController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/9/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit


class CityListController: UITableViewController
{
    
    var placeArray: [Restaurant] = []
    
    var cityArray: [String] = []
    
    var yelper = Yelper.sharedInstance()
    
    var navController = UINavigationController()
    
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        cityArray = yelper.cityArray
        
        navController = self.storyboard?.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCity = cityArray[(indexPath.row)]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        
        
        // Configure cell
        cell.backgroundColor = UIColor.lightGray
        
        cell.nameLabel?.text = aCity
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextController = storyboard?.instantiateViewController(withIdentifier: "PlaceListController") as! UIViewController
        
        var filteredPlaces: [Restaurant] = []
        
        for i in yelper.placeArray
        {
            if i.city == cityArray[(indexPath.row)]
            {
                filteredPlaces.append(i)
            }
            
            yelper.filteredArray = filteredPlaces
        }
        navController.pushViewController(nextController, animated: true)        
    }
    
    
    
    
    
    
    
    
    
    
}
