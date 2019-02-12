//
//  BookTripViewController.swift
//  WanderiftApp
//
//  Created by Zachary Burau on 11/11/18.
//  Copyright © 2018 Wanderift. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

class BookTripViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref:DatabaseReference?
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    var departurecity:[String] = []
    var arrivalcity:[String] = []
    
    private var departuredatesubmit: UIDatePicker?
    private var returndatesubmit: UIDatePicker?

    @IBOutlet weak var AccountEmail: UITextField!
    
    var myString = String()
    
    @IBOutlet weak var DepartureCity: UITextField!
    @IBOutlet weak var ArrivalCity: UITextField!
    
    @IBOutlet weak var DepartureDate: UITextField!
    @IBOutlet weak var ReturnDate: UITextField!
    
    @IBOutlet weak var Book: UIButton!
    
    @IBAction func Book(_ sender: Any)
    {
        ref = Database.database().reference()
        
        if DepartureCity.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(DepartureCity.text);ref?.child("Trip Histroy Departure City").childByAutoId().setValue(DepartureCity.text)
            DepartureCity.text = ""
        }
        
        if ArrivalCity.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(ArrivalCity.text);ref?.child("Trip Histroy Arrival City").childByAutoId().setValue(ArrivalCity.text)
            ArrivalCity.text = ""
        }
    
        if DepartureDate.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(DepartureDate.text);ref?.child("Trip Histroy Departure Date").childByAutoId().setValue(DepartureDate.text)
            DepartureDate.text = ""
        }
        
        if ReturnDate.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(ReturnDate.text);ref?.child("Trip Histroy Return Date").childByAutoId().setValue(ReturnDate.text)
            ReturnDate.text = ""
        }
        
        if AccountEmail.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(AccountEmail.text)
            AccountEmail.text = ""
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Your Trip is Booked"
        content.body = "Your booking request has been processed and your trip is booked. Your trip details have been emailed to you. Enjoy your trip."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    @IBAction func Logout(_ sender: UIButton)
    {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "SegueLogout", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AccountEmail.text = myString
        
       
        
        departuredatesubmit = UIDatePicker()
        departuredatesubmit?.datePickerMode = .date
        departuredatesubmit?.addTarget(self, action: #selector(SubmitBookingRequestViewController.dateChanged(departuredatesubmit:)),for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BookTripViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        DepartureDate.inputView = departuredatesubmit
        
        returndatesubmit = UIDatePicker()
        returndatesubmit?.datePickerMode = .date
        returndatesubmit?.addTarget(self, action: #selector(BookTripViewController.dateChanged(returndatesubmit:)),for: .valueChanged)
        
        view.addGestureRecognizer(tapGesture)
        
        ReturnDate.inputView = returndatesubmit

        // Do any additional setup after loading the view.
        
        departurecity = ["Austin","Atlanta","Denver","Las Vegas", "Los Angeles"]
        
        arrivalcity = ["Albuquerque","Austin","Charlotte","Chicago","Cincinnati","Colorado Springs","Dallas","Denver","Detroit","Houston","Indianapolis","Kansas City","Las Vegas","Los Angeles","Memphis","Milwaukee","Minneapolis","Nashville","New Orleans","New York","Oklahoma City","Orlando","Philadelphia","Phoenix","Salt Lake City","San Antonio","San Diego","San Fransisco","Seattle"]
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(departuredatesubmit: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        DepartureDate.text = dateFormatter.string(from: departuredatesubmit.date)
        view.endEditing(true)
        
    }
    
    @objc func dateChanged(returndatesubmit: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        ReturnDate.text = dateFormatter.string(from: returndatesubmit.date)
        view.endEditing(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == DepartureCity {
            return departurecity.count
        } else if currentTextField == ArrivalCity {
            return arrivalcity.count
        } else {
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if currentTextField == DepartureCity {
            return departurecity[row]
        } else if currentTextField == ArrivalCity{
            return arrivalcity[row]
        } else {
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == DepartureCity {
            DepartureCity.text = departurecity[row]
            self.view.endEditing(true)
        } else if currentTextField == ArrivalCity {
            ArrivalCity.text = arrivalcity[row]
            self.view.endEditing(true)
        }
    }
    
    //Text Field Delegate used
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        if currentTextField == DepartureCity {
            currentTextField.inputView = pickerView
        } else if currentTextField == ArrivalCity {
            currentTextField.inputView = pickerView
        }
        
    }
}
