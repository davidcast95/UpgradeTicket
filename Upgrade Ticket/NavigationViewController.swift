//
//  NavigationViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/6/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController {

    @IBOutlet weak var mainNav: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hidden navigation bar default
        self.navigationController?.isNavigationBarHidden = true
        navigationProperties.color = mainNav.backgroundColor!
        navigationProperties.height = mainNav.frame.height
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    //Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
