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
    var favorited: Bool = false
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
    @IBOutlet weak var dishLabel: UILabel!
    
    override func viewDidLoad()
    {
        super .viewDidLoad()
        setDetails()
        if favorited
        {
            addButton.isHidden = true
            addButton.isUserInteractionEnabled = false
            
            if myFavoriteDish.text == "What did you like here?"
            {
            myFavoriteDish.clearsOnBeginEditing = true
            myFavoriteDish.alpha = 0.3
            }
            else
            {
                myFavoriteDish.alpha = 1.0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super .viewWillAppear(true)
        cityExists = false
        setupFetchedResultsController()
    }
    
    func setDetails()
    {
        name.text = chosenPlace?.name
        location.text = chosenPlace?.city
        phone.text = chosenPlace?.phone
        rating.text = chosenPlace?.rating.description
        
        if favorited
        {
            myFavoriteDish.isHidden = false
            myFavoriteDish.text = place?.note ?? "What did you like here?"
            dishLabel.isHidden = false
        }
        else
        {
            myFavoriteDish.isHidden = true
            dishLabel.isHidden = true
        }
    }
    
    func saveChosenPlace(_ restaurant: Restaurant)
    {
            let newPlace = Place(context: self.dataController.viewContext)
            newPlace.name = restaurant.name
            newPlace.city = restaurant.city
            newPlace.image = restaurant.image
            newPlace.phone = restaurant.phone
            newPlace.rating = restaurant.rating
        if !cityExists
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
        addButton.isUserInteractionEnabled = false
        addButton.alpha = 0.2
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
            }
        }
    }
    
    @IBAction func typeMyDish(_ sender: Any) {
        place?.note = myFavoriteDish.text
        do
        {
            try dataController.viewContext.save()
        }
        catch
        {
            print("unable to save")
        }
    }
    
    @objc fileprivate func setupFetchedResultsController()
    {
        let fetchRequest:NSFetchRequest<City> = City.fetchRequest()
        //let cityPredicate = NSPredicate(format: "%K = %@", "name", "\(chosenPlace!.city)")
        //fetchRequest.predicate = cityPredicate
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
