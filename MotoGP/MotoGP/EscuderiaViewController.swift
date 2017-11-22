//
//  ViewController.swift
//  MotoGP
//
//  Created by Juan Rodríguez Baeza on 22/11/17.
//  Copyright © 2017 Juan Rodríguez Baeza. All rights reserved.
//

import UIKit
import CoreData

class EscuderiaViewController: UIViewController {
    
    var escuderia = NSManagedObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelar(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

