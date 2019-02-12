//
//  LoginViewController.swift
//  WanderiftApp
//
//  Created by Zachary Burau on 11/11/18.
//  Copyright © 2018 Wanderift. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var EnterEmail: UITextField!
    @IBOutlet weak var EnterPassword: UITextField!
    
    @IBOutlet weak var Go: UIButton!
    
    @IBAction func Go(_ sender: UIButton)
    {
        if EnterEmail.text != "" && EnterPassword.text != ""
        {
            Auth.auth().signIn(withEmail: EnterEmail.text!, password: EnterPassword.text!, completion: { (user, error) in if user != nil
                {
                  //Sign in successful
                  self.performSegue(withIdentifier: "SegueLogin", sender: self)
                }
                else
                {
                    if let myError = error?.localizedDescription
                    {
                        print(myError)
                    }
                    else
                    {
                        print("ERROR")
                    }
                }
            })
        }
        if EnterEmail.text != ""
        {
            performSegue(withIdentifier: "SegueLogin", sender: self)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let BookTripController = segue.destination as! BookTripViewController
        BookTripController.myString = EnterEmail.text!
    }
    
    
    @IBAction func ForgotPassword(_ sender: UIButton)
    {
        Auth.auth().sendPasswordReset(withEmail: EnterEmail.text!) { (error) in
            // ...
        }
    }
 
        override func viewDidLoad() {
            super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
