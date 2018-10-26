//
//  StartScreenViewController.swift
//  Keto-Station
//
//  Created by Ali Halawa on 9/9/18.
//  Copyright © 2018 Ali Halawa. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
