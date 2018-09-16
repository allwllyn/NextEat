//
//  ListController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/9/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit


class PlaceListController: UITableViewController
{
    
    var placeArray = [Place]()
    
    @IBOutlet var placeTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        placeTable.delegate = self
        placeArray = Yelper.sharedInstance().placeArray.sorted(by: {$0.name > $1.name})
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aPlace = placeArray[(indexPath.row)]
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCell
        
        // Configure cell
        cell.placeName?.text = aPlace.name
        
        return cell
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
