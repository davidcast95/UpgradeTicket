//
//  ConfirmationEmailViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 7/14/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ConfirmationEmailViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    var username = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLabel.text = "Hi, \(username)! Your data has been registered."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
