//
//  LoginVC.swift
//  GroupOrders
//
//  Created by Penny Huang on 2020/5/5.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginVC: UIViewController {

    struct PropertyKeys {
        static let showNavigation = "goToNavigation"
//        static let showForm = "loginToFormVC"
    }
    
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var pwTextFieldOutlet: UITextField!
    
    @IBOutlet weak var submitButtonOutlet: UIButton!

    @IBOutlet weak var fbButtonOutlet: UIButton!
    
    @IBOutlet weak var indicatorOutlet: UIActivityIndicatorView!
    
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    @IBAction func unwindToLoginVC(_ unwind: UIStoryboardSegue) {
        
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            submitButtonOutlet.setTitle("Sign In", for: .normal)
            nameTextFieldOutlet.isHidden = true
        } else {
            submitButtonOutlet.setTitle("Register", for: .normal)
            nameTextFieldOutlet.isHidden = false
        }
    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if let email = emailTextFieldOutlet.text, let password = pwTextFieldOutlet.text {
//            print(email)
//            print(password)
            
            if segmentedControlOutlet.selectedSegmentIndex == 1 {
                
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    
                    if let e = error {
                        
                        let alert = UIAlertController(title: "Oops!", message: "\(e.localizedDescription)", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Cancel", style: .cancel) {
                            (alertAction) in
                        }
                        alert.addAction(alertAction)
                        self!.present(alert, animated: true, completion: nil)
                        print(e)
                    }
//                  guard let strongSelf = self else { return }
                    self!.performSegue(withIdentifier: PropertyKeys.showNavigation, sender: self)
                }
                
            } else {
                if nameTextFieldOutlet.text == "" {
                    nameTextFieldOutlet.layer.borderWidth = 1
                    nameTextFieldOutlet.layer.borderColor = UIColor.red.cgColor
                } else {
                    nameTextFieldOutlet.layer.borderWidth = 0
                    
                    indicatorOutlet.startAnimating()
                    indicatorOutlet.layer.cornerRadius = indicatorOutlet.frame.height / 5
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

                        if let e = error {
                            self.indicatorOutlet.stopAnimating()
                            
                            let alert = UIAlertController(title: "Oops!", message: "\(e.localizedDescription)", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Cancel", style: .cancel) {
                                (alertAction) in
                            }
                            alert.addAction(alertAction)
                            self.present(alert, animated: true, completion: nil)
                        
                            print(e)
                            
                        } else {

                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = self.nameTextFieldOutlet.text
                            changeRequest?.commitChanges { (error) in

                                if let e = error {
                                    self.indicatorOutlet.stopAnimating()
                                    print(e.localizedDescription)
                                } else {

                                    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in

                                        if let e = error {
                                            self!.indicatorOutlet.stopAnimating()
                                          let alert = UIAlertController(title: "Oops!", message: "\(e.localizedDescription)", preferredStyle: .alert)
                                          let alertAction = UIAlertAction(title: "Cancel", style: .cancel) {
                                              (alertAction) in
                                          }
                                          alert.addAction(alertAction)
                                          self!.present(alert, animated: true, completion: nil)
                                          print(e)
                                        } else {
                                            self!.performSegue(withIdentifier: PropertyKeys.showNavigation, sender: self)
                                        }
    //                                    guard let strongSelf = self else { return }
                                    }
                                }
                            }

                        }
                    }
                }

            }
        }
        
    }
    
    
    @IBAction func fbButtonPressed(_ sender: Any) {
        let manager = LoginManager()
        manager.logOut()
        manager.logIn(permissions:["public_profile", "email"], from: nil) { (result, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else if result?.isCancelled == true{
                    print("Login is cancelled")
                } else  {
                    
                    print("Logged in")
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        if let error = error {
                            print("Sign in error: \(error)")
                        } else {
                            self.performSegue(withIdentifier: PropertyKeys.showNavigation, sender: self)
                        }
                        
                    }


                }
                             
            }
        
    }
    
    
    
    
    
    func updateUI() {
        if segmentedControlOutlet.selectedSegmentIndex == 0 {
            nameTextFieldOutlet.isHidden = false
            submitButtonOutlet.setTitle("Regiester", for:.normal)

        } else {
            nameTextFieldOutlet.isHidden = true
            submitButtonOutlet.setTitle("Login", for: .normal)

        }
    }
    
    func testCurrentUser() {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                // User is signed in
                // ...
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let email = user.email
                    let userName = user.displayName
                    print("User Information: UID: \(uid), Email: \(email ?? "No available email"), User Name: \(userName ?? "No available User Name")")
                }
            } else {
                print("current user is nil")
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButtonOutlet.layer.cornerRadius = submitButtonOutlet.frame.height / 5
        fbButtonOutlet.layer.cornerRadius = fbButtonOutlet.frame.height / 5
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicatorOutlet.stopAnimating()
        nameTextFieldOutlet.isHidden = false
        segmentedControlOutlet.selectedSegmentIndex = 0
        nameTextFieldOutlet.text = ""
        emailTextFieldOutlet.text = ""
        pwTextFieldOutlet.text = ""

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        indicatorOutlet.stopAnimating()
    }


}
