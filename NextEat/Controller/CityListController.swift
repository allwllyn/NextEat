//
//  CityListViewController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/9/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CityListController: UITableViewController, NSFetchedResultsControllerDelegate
{
    
    var placeArray: [Restaurant] = []
    
    var cityArray: [String] = []
    var fetchedResultsController: NSFetchedResultsController<Place>!
    var yelper = Yelper.sharedInstance()
    var dataController: DataController!

    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        if dataController != nil
        {
            print("dataController is present")
        }
        else
        {
            print("dataController is not here")
        }
        
        cityArray = yelper.cityArray
        
        
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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "placeListController") as! PlaceListController
        
        vc.dataController = dataController
        vc.cityName = cityArray[indexPath.row]
        vc.fetching = true
        
        /*var filteredPlaces: [Restaurant] = []
        
        for i in yelper.placeArray
        {
            if i.city == cityArray[(indexPath.row)]
            {
                filteredPlaces.append(i)
            }
            
            yelper.filteredArray = filteredPlaces
        }*/
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc fileprivate func setupFetchedResultsController()
    {
        let fetchRequest:NSFetchRequest<Place> = Place.fetchRequest()
        let cityPredicate = NSPredicate(format: "%K = %@", "city", "Atlanta")
        fetchRequest.predicate = cityPredicate
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PlaceListController
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                vc.cityName = cityArray[indexPath.row]
                vc.fetching = true
            }
        }
    }
    
    
    
    
}
