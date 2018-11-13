//
//  SettingViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/13/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Actions
    @IBAction func LogoutTapped(_ sender: AnyObject) {
        activeUser.removeObject(forKey: "id")
        activeUser.removeObject(forKey: "name")
        activeUser.removeObject(forKey: "email")
        SystemReset()
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "home") as? HomeViewController {
            self.present(homeVC, animated: true, completion: nil)
        }
    }
    

}
