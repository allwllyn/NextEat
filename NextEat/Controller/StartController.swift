//
//  ViewController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/3/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class StartController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listButton: UIBarButtonItem!
    @IBOutlet weak var findNearTypeButton: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Place>!
    var startDataController: DataController!
    var location: CLLocationCoordinate2D?
    let yelper = Yelper.sharedInstance()
    let localManager = CLLocationManager()
    let alert = UIAlertController(title: "Trouble Connecting", message: "There appears to be a network problem.", preferredStyle: .alert)
    let locationAlert = UIAlertController(title: "Location Servicis", message: "Can't get your location. Make sure location services are on.", preferredStyle: .alert)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchText.delegate = self
        cityText.delegate = self
        findNearTypeButton.alpha = 0.4
        icon.isUserInteractionEnabled = true
        icon.image = #imageLiteral(resourceName: "NextEatStartGif.png")
        icon.rotate360Degrees()
        tapRecognizer.delegate = self
        actIndicator.isHidden = true
        localManager.delegate = self
        self.localManager.requestAlwaysAuthorization()
        self.localManager.requestWhenInUseAuthorization()
        setupFetchedResultsController()
        
        if CLLocationManager.locationServicesEnabled()
        {
            localManager.delegate = self
            localManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            localManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        subscribeKeyboardNotifications()
        
        searchText.text = nil
        cityText.text = nil
        yelper.filteredArray = []
        actIndicator.isHidden = true
        self.view.alpha = 1.0
        
        setupFetchedResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
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
    
    
    @IBAction func activateFindNear(_ sender: Any) {
        
        findNearTypeButton.isEnabled = true
        findNearTypeButton.alpha = 1.0
        
    }
    
    @IBAction func searchByTypedCity(_ sender: Any) {
        
        activateActView()
        
        yelper.placeArray = []
        
        yelper.searchByPhrase(cityText: cityText.text!, termText: searchText.text!)
        {
            (success,error) in
            if error != nil
            {
                DispatchQueue.main.sync
                {
                    self.formatAlert(self.alert)
                    self.deactivateActView()
                }
                
            }
            else if success
            {
                DispatchQueue.main.sync {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "placeListController") as! PlaceListController
                    
                    vc.fetching = false
                    vc.dataController = self.startDataController
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func searchByLocation(_ sender: Any) {
        activateActView()
        
        yelper.placeArray = []
        
        location = localManager.location?.coordinate
        
        if location != nil
        {
            yelper.searchNearby(latitude: (location?.latitude.description)!, longitude: (location?.longitude.description)!, text: searchText.text!)
            {
                (success,error) in
                
                    if error != nil
                    {
                        DispatchQueue.main.sync
                        {
                            self.deactivateActView()
                            self.formatAlert(self.alert)
                        }
                        
                    }
                    else if success
                    {
                        DispatchQueue.main.sync
                        {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "placeListController") as! PlaceListController
                            
                            vc.fetching = false
                            vc.dataController = self.startDataController
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
            }
            
           /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "placeListController") as! PlaceListController
            
            vc.fetching = false
            vc.dataController = startDataController
            
            self.navigationController?.pushViewController(vc, animated: true)*/
        }
        else
        {
            deactivateActView()
            formatAlert(locationAlert)
        }
    }
    
    
    
    func activateActView()
    {
        view.alpha = 0.5
        actIndicator.isHidden = false
        actIndicator.startAnimating()
    }
    
    func deactivateActView()
    {
        view.alpha = 1.0
        actIndicator.isHidden = true
        actIndicator.stopAnimating()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        location = locValue
    }
    //MARK: Keyboard notifications - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification)
    {
        
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification)
    {
        view.frame.origin.y = 0
    }
    
    func subscribeKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
    }
    
}
