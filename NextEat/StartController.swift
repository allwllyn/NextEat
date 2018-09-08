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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


@IBAction func typeSearch(_ sender: Any) {

        Yelper.sharedInstance().searchByPhrase(AnyObject.self as AnyObject, text: searchText)
    }
    
}

