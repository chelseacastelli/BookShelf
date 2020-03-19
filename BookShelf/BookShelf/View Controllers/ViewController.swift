//
//  ViewController.swift
//  BookShelf
//
//  Created by ChelseaAnne Castelli on 3/18/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }


}

