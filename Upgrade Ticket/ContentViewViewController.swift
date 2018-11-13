//
//  ContentViewViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/13/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ContentViewViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Function
    
}
