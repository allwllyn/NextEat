//
//  PlaceDetailController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/11/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit

class PlaceDetailController: UIViewController
{
    
    var chosenPlace: Restaurant?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        setDetails()
    }
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var website: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    
    
    @IBOutlet weak var myFavoriteDish: UITextField!
    
    func setDetails() {
        
        name.text = chosenPlace?.name
        location.text = chosenPlace?.city
        website.text = chosenPlace?.website
        rating.text = chosenPlace?.phone
        
    }
    
    
    
    
}
