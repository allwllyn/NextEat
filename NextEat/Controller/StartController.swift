//
//  ViewController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/3/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import UIKit

class StartController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        icon.isUserInteractionEnabled = true
        icon.image = #imageLiteral(resourceName: "NextEatStartGif.png")
        icon.rotate360Degrees()
        tapRecognizer.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        searchText.text = nil
    }


    @IBAction func switchIcon(_ gestureRecognizer: UITapGestureRecognizer)
    {
        if gestureRecognizer.state == .ended
        {
            if icon.image == #imageLiteral(resourceName: "NextEatStartGif.png") {
                icon.image = #imageLiteral(resourceName: "sushiCatIcon.png")
            }
        
            else if icon.image == #imageLiteral(resourceName: "sushiCatIcon.png"){
                icon.image = #imageLiteral(resourceName: "NextEatStartGif.png")
            }
        }
    }
    
    @IBAction func typeSearch(_ sender: Any)
    {

        Yelper.sharedInstance().searchByPhrase(AnyObject.self as AnyObject, text: searchText)
        {
        success in
            if success
            {
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "navController") as! UINavigationController
                let nextController = self.storyboard?.instantiateViewController(withIdentifier: "PlaceListController") as! UIViewController
                
                navController.pushViewController(nextController, animated: true)
            }
    }
    
    
    }
    
    @IBAction func presentList(_ sender: Any) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        let nextController = storyboard?.instantiateViewController(withIdentifier: "PlaceListController") as! UIViewController
        
        performSegue(withIdentifier: "showCityList", sender: self)
    }
}

