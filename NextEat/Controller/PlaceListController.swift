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


class PlaceListController: UITableViewController
{
    
    var tableTimer: Timer!
    let yelper = Yelper.sharedInstance()
    var placeArray: [Restaurant?] = []
    var chosenPlace: Restaurant?
    var fetchedResultsController: NSFetchedResultsController<Place>!
    
    @IBOutlet var placeTable: UITableView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        placeTable.delegate = self
        
        if yelper.filteredArray.count != 0
        {
            placeArray = yelper.filteredArray
        }
        else
        {
            placeArray = yelper.placeArray.sorted(by: {$0.name < $1.name})
        }
        
        
        tableTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reloadAfterTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if yelper.filteredArray.count != 0
        {
            placeArray = yelper.filteredArray
        }
        else
        {
            placeArray = yelper.placeArray.sorted(by: {$0.name < $1.name})
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if placeArray.count != 0{
       return placeArray.count
        }
        else{
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCell
        
     //   {
        if placeArray.count != 0
        {
          if let aPlace = placeArray[(indexPath.row)]
          {  // Configure cell
            let url = URL(string: aPlace.image)
            let data = try? Data(contentsOf: url!)
        
                if let imageData = data
                {
                    print(imageData)
                    let image = UIImage(data: imageData, scale: 0.7)
                    cell.placeImage?.contentMode = .scaleAspectFit
                    cell.placeImage?.clipsToBounds = true
                    cell.placeImage?.image = image!
                    cell.activityView.isHidden = true
                    cell.activityView.stopAnimating()
                    cell.backgroundColor = UIColor.clear
                    cell.placeName?.text = aPlace.name
                }
            }
          else
            {
            cell.backgroundColor = UIColor.lightGray
            cell.activityView.isHidden = false
            cell.activityView.startAnimating()
            cell.placeName?.text = nil
            cell.isUserInteractionEnabled = false
            }
        }
        
        else
        {
            cell.backgroundColor = UIColor.lightGray
            cell.placeImage?.image = nil
            cell.placeName?.text = ""
            cell.activityView.isHidden = false
            cell.activityView.startAnimating()
            cell.isUserInteractionEnabled = false
        }
     //   }
        
        return cell
    }
    
    
    @objc func reloadAfterTime(delayTime: TimeInterval = 0.7)
    {
        DispatchQueue.main.async
            {
                if self.yelper.filteredArray.count != 0
                {
                    self.placeArray = self.yelper.filteredArray
                }
                else
                {
                    self.placeArray = self.yelper.placeArray.sorted(by: {$0.name < $1.name})
                }
            self.placeTable.reloadData()
            
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? PlaceDetailController
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                vc.chosenPlace = placeArray[(indexPath.row)]
            }
        }
    }
    
   
    
    
    
    
}
