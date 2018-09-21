//
//  ViewController.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/3/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import UIKit

class StartController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        icon.image = #imageLiteral(resourceName: "NextEatStartGif.png")
        icon.rotate360Degrees()
        
    }


    @IBAction func switchIcon(_ sender: Any)
    {
        
        if icon.image == #imageLiteral(resourceName: "NextEatStartGif.png") {
            icon.image = #imageLiteral(resourceName: "sushiCatIcon.png")
        }
        
        else if icon.image == #imageLiteral(resourceName: "sushiCatIcon.png"){
            icon.image = #imageLiteral(resourceName: "NextEatStartGif.png")
        }
    }
    
@IBAction func typeSearch(_ sender: Any) {

        Yelper.sharedInstance().searchByPhrase(AnyObject.self as AnyObject, text: searchText)
    }
    
    @IBAction func presentList(_ sender: Any) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        let nextController = storyboard?.instantiateViewController(withIdentifier: "PlaceListController") as! UIViewController
        
        performSegue(withIdentifier: "showList", sender: self)
    }
}

