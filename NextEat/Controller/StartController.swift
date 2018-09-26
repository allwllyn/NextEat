//
//  ViewController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/3/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import UIKit
import CoreData

class StartController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate
{

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listButton: UIBarButtonItem!
    var fetchedResultsController: NSFetchedResultsController<Place>!
    var startDataController: DataController!
    let yelper = Yelper.sharedInstance()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        icon.isUserInteractionEnabled = true
        icon.image = #imageLiteral(resourceName: "NextEatStartGif.png")
        icon.rotate360Degrees()
        tapRecognizer.delegate = self
        actIndicator.isHidden = true
        
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        searchText.text = nil
        yelper.filteredArray = []
        actIndicator.isHidden = true
        self.view.alpha = 1.0
        
       setupFetchedResultsController()
    }
    
    @IBAction func switchIcon(_ gestureRecognizer: UITapGestureRecognizer)
    {
        if gestureRecognizer.state == .ended
        {
            if icon.image == #imageLiteral(resourceName: "NextEatStartGif.png")
            {
                icon.image = #imageLiteral(resourceName: "sushiCatIcon.png")
            }
        
            else if icon.image == #imageLiteral(resourceName: "sushiCatIcon.png")
            {
                icon.image = #imageLiteral(resourceName: "NextEatStartGif.png")
            }
        }
    }
    
    @IBAction func typeSearch(_ sender: Any)
    {
        self.view.alpha = 0.5
        actIndicator.isHidden = false
        actIndicator.startAnimating()
        
        Yelper.sharedInstance().searchByPhrase(self, text: searchText)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "placeListController") as! PlaceListController

        vc.fetching = false
        vc.dataController = startDataController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func setupFetchedResultsController()
    {
        let fetchRequest:NSFetchRequest<Place> = Place.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: startDataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do
        {
            try fetchedResultsController.performFetch()
            do
            {
                var count = try startDataController.viewContext.fetch(fetchRequest).count
                if count == 0{
                    listButton.isEnabled = false
                }
                else if count > 0
                {
                    listButton.isEnabled = true
                }
                else
                {
                    listButton.isEnabled = false
                }
            }
            catch
            {
                print("couldn't perform fetch")
            }
        }
        catch
        {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    @IBAction func presentList(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "cityController") as! CityListController
        
        vc.dataController = startDataController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
