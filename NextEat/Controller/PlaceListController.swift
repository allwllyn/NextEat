//
//  ListController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/9/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PlaceListController: UITableViewController, NSFetchedResultsControllerDelegate
{
    
    var tableTimer: Timer!
    var fetchTimer: Timer!
    let yelper = Yelper.sharedInstance()
    var placeArray: [Restaurant?] = []
    var chosenPlace: Restaurant?
    var fetchedResultsController: NSFetchedResultsController<Place>!
    var dataController: DataController!
    var place: Place!
    var searchCity: City?
    var cityName: String?
    var fetching: Bool = false

    
    @IBOutlet var placeTable: UITableView!
    
    override func viewDidLoad()
    {
        super .viewDidLoad()
        
        if dataController != nil {
            print("dataController still here")
        }
        
       else if dataController == nil
        {
            print("dataController has disappeared already")
        }
        
        placeTable.delegate = self
        
        placeTable.allowsMultipleSelectionDuringEditing = false
        
        if fetching
        {
            setupFetchedResultsController()
            // fetchTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(setupFetchedResultsController), userInfo: nil, repeats: false)
        }
        
        if !fetching
        {
            tableTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reloadAfterTime), userInfo: nil, repeats: true)
            
            placeArray = yelper.placeArray.sorted(by: {$0.name < $1.name})
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fetching
        {
           // fetchedResults soemthing
        }
        else
        {
            placeArray = yelper.placeArray.sorted(by: {$0.name < $1.name})
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if fetching
        {
            return fetchedResultsController.fetchedObjects?.count ?? 1
        }
        else{
            if placeArray.count != 0
            {
                return placeArray.count
            }
            else
            {
                return 1
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCell
        
        if fetching
        {
            if let aPlace = fetchedResultsController.fetchedObjects?[(indexPath.row)]
          {  // Configure cell
                    cell.placeImage?.contentMode = .scaleAspectFit
                    cell.placeImage?.clipsToBounds = true
                    cell.placeImage?.image = UIImage(data: aPlace.image!)
                    cell.activityView.isHidden = true
                    cell.activityView.stopAnimating()
                    cell.backgroundColor = UIColor.clear
                    cell.placeName?.text = aPlace.name
            }
          else
            {
            configureNilCell(cell)
            }
        }
        else
        {
            if placeArray.count != 0
            {
                let aPlace = placeArray[(indexPath.row)]!
                cell.placeImage?.contentMode = .scaleAspectFit
                cell.placeImage?.clipsToBounds = true
                cell.placeImage?.image = UIImage(data: aPlace.image!)
                cell.activityView.isHidden = true
                cell.activityView.stopAnimating()
                cell.backgroundColor = UIColor.clear
                cell.placeName?.text = aPlace.name
                
            }
            else
            {
                configureNilCell(cell)
            }
        }
        return cell
    }
    
    private func configureNilCell(_ cell: PlaceCell)
    {
        cell.backgroundColor = UIColor.lightGray
        cell.activityView.isHidden = false
        cell.activityView.startAnimating()
        cell.placeName?.text = ""
        cell.isUserInteractionEnabled = false
    }
    
    
    @objc func reloadAfterTime(delayTime: TimeInterval = 0.7)
    {
        DispatchQueue.main.async
        {
            self.placeArray = self.yelper.placeArray.sorted(by: {$0.name < $1.name})
            self.placeTable.reloadData()
        }
    }
    
    @objc fileprivate func setupFetchedResultsController()
    {
        let fetchRequest:NSFetchRequest<Place> = Place.fetchRequest()
        let cityPredicate = NSPredicate(format: "%K = %@", "city", "\(cityName!)")
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
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! PlaceDetailController

        vc.dataController = dataController
            
        let indexPath = tableView.indexPathForSelectedRow!
        
                if fetching
                {
                    vc.chosenPlace = Restaurant((fetchedResultsController.fetchedObjects?[(indexPath.row)])!)
                    vc.place = fetchedResultsController.fetchedObjects?[(indexPath.row)]
                    vc.favorited = true
                }
                else
                {
                    vc.chosenPlace = placeArray[(indexPath.row)]
                    vc.favorited = false
                }
    }
    
   
    
    
}
