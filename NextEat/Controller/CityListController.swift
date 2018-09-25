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
    
    //var cityArray: [String] = []
    var fetchedResultsController: NSFetchedResultsController<City>!
    var citiesFetched: Bool = false
    var yelper = Yelper.sharedInstance()
    var dataController: DataController!

    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
       setupFetchedResultsController()
        
        //cityArray = yelper.cityArray
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fetchedResultsController.fetchedObjects!.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
            let aCity = fetchedResultsController.fetchedObjects![(indexPath.row)]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
            cell.backgroundColor = UIColor.lightGray
            cell.nameLabel?.text = aCity.name
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "placeListController") as! PlaceListController
        vc.dataController = dataController
        vc.cityName = fetchedResultsController.fetchedObjects![(indexPath.row)].name
        vc.fetching = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc fileprivate func setupFetchedResultsController()
    {
        let fetchRequest:NSFetchRequest<City> = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do
        {
            try fetchedResultsController.performFetch()
            /*do
            {
                var count = try dataController.viewContext.fetch(fetchRequest).count
                if count == 0
                {
                    citiesFetched = false
                }
                else
                {
                    citiesFetched = true
                }
            }
            catch
            {
                print("counld not count fetch")
            }*/
        }
        catch
        {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
}
