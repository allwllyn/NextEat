//
//  PlaceDetailController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/11/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PlaceDetailController: UIViewController, NSFetchedResultsControllerDelegate
{
    
    var chosenPlace: Restaurant?
    
    var place: Place?
    
    var currentCity: City?
    
    var citiesFetched: Bool = false
    
    var cityExists: Bool = false
    
    var dataController: DataController!
    
    var fetchedResultsController: NSFetchedResultsController<City>!
    
    let yelper = Yelper.sharedInstance()
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var myFavoriteDish: UITextField!
    
    override func viewDidLoad()
    {
        super .viewDidLoad()
        
        setDetails()
    }
    
    func setDetails()
    {
        name.text = chosenPlace?.name
        location.text = chosenPlace?.city
        phone.text = chosenPlace?.phone
        rating.text = chosenPlace?.rating.description
    }
    
    func saveChosenPlace(_ restaurant: Restaurant)
    {
            let newPlace = Place(context: self.dataController.viewContext)
            newPlace.name = restaurant.name
            newPlace.city = restaurant.city
            newPlace.image = restaurant.image
            newPlace.phone = restaurant.phone
            newPlace.rating = restaurant.rating
        if cityExists == false
        {
            let newCity = City(context: self.dataController.viewContext)
            newCity.name = restaurant.city
            currentCity = newCity
        }
            newPlace.location = currentCity!

            do
            {
                try dataController.viewContext.save()
            }
            catch
            {
                print("couldn't save")
            }
            
    }
    
    @IBAction func savePlace(_ sender: Any)
    {
        checkCities()
        
        saveChosenPlace(chosenPlace!)
    }
    
    func checkCities()
    {
        if citiesFetched
        {
            for i in fetchedResultsController.fetchedObjects!
            {
                if i.name == chosenPlace?.city
                {
                    cityExists = true
                    currentCity = i
                    break
                }
                else
                {
                    cityExists = false
                    continue
                }
            }
        }
        else
        {
            cityExists = false
        }
    }
    
    
    @objc fileprivate func setupFetchedResultsController()
    {
        let fetchRequest:NSFetchRequest<City> = City.fetchRequest()
        let cityPredicate = NSPredicate(format: "%K = %@", "name", "\(chosenPlace!.city)")
        fetchRequest.predicate = cityPredicate
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            do
            {
                var count = try dataController.viewContext.count(for: fetchRequest)
                if count == 0
                {
                    citiesFetched = false
                }
                else
                {
                    citiesFetched = true
                }
            }
            catch {
                print("fetch count didn't work")
            }
        }
        catch
        {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}
