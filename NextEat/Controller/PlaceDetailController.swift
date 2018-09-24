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
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        setDetails()
    }
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var myFavoriteDish: UITextField!
    
    func setDetails() {
        
        name.text = chosenPlace?.name
        location.text = chosenPlace?.city
        phone.text = chosenPlace?.phone
        rating.text = chosenPlace?.rating.description
        
    }
    
    func savePlace(_ restaurant: Restaurant)
    {
        if dataController == nil
        {
            print("the data controller is not being passed")
        }
        else
        {
        let newPlace = Place(context: self.dataController.viewContext)
        newPlace.name = restaurant.name
        newPlace.city = restaurant.city
        newPlace.image = restaurant.image
        newPlace.phone = restaurant.phone
        newPlace.rating = restaurant.rating
        }
    }
    
    @IBAction func savePlace(_ sender: Any)
    {
        savePlace(chosenPlace!)
        //print("saving \(chosenPlace?.name)")
    }
    
}
