//
//  LoginViewController.swift
//  BookShelf
//
//  Created by ChelseaAnne Castelli on 3/18/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        // Hide error label
        errorLabel.alpha = 0
        
        // Style elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    func validateFields() -> String? {
           
           // Check that all fields are filled in
           if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
               return "Please fill in all fields"
           }

           
           return nil
       }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // TODO: Validate Text Fields
        let error = validateFields()
        
        if error != nil {
            self.errorLabel.text = error
            self.errorLabel.alpha = 1
        } else {
       
            // Create cleaned versions of the text field
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
               
               if error != nil {
                   // Couldn't sign in
                   self.errorLabel.text = error!.localizedDescription
                   self.errorLabel.alpha = 1
               }
               else {
                   
                   let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                   
                   self.view.window?.rootViewController = homeViewController
                   self.view.window?.makeKeyAndVisible()
               }
            }
        }
    }


}
