//
//  SubmitBookingRequestViewController.swift
//  WanderiftApp
//
//  Created by Zachary Burau on 10/31/18.
//  Copyright © 2018 Wanderift. All rights reserved.
//

import UIKit
import FirebaseDatabase
import UserNotifications

class SubmitBookingRequestViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref:DatabaseReference?

    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    var departurecity:[String] = []
    var arrivalcity:[String] = []
    
    private var departuredatesubmit: UIDatePicker?
    private var returndatesubmit: UIDatePicker?
    
    @IBOutlet weak var DepartureDate: UITextField!
    @IBOutlet weak var ReturnDate: UITextField!
    
    
    @IBOutlet weak var DepartureCity: UITextField!
    @IBOutlet weak var ArrivalCity: UITextField!
    
    @IBOutlet weak var AccountEmail: UITextField!
    
    @IBOutlet weak var RequestTrip: UIButton!
    @IBAction func RequestTrip(_ sender: Any)
    {
        ref = Database.database().reference()
        
        if DepartureCity.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(DepartureCity.text)
            DepartureCity.text = ""
        }
        
        if ArrivalCity.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(ArrivalCity.text)
            ArrivalCity.text = ""
        }
        
        if DepartureDate.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(DepartureDate.text)
            DepartureDate.text = ""
        }
        
        if ReturnDate.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(ReturnDate.text)
            ReturnDate.text = ""
        }
        
        if AccountEmail.text != ""
        {
            ref?.child("Booking Request").childByAutoId().setValue(AccountEmail.text)
            AccountEmail.text = ""
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Trip is Booked"
        content.body = "Your trip has been booked and the trip details have been emailed to you. Enjoy your trip!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departuredatesubmit = UIDatePicker()
        departuredatesubmit?.datePickerMode = .date
        departuredatesubmit?.addTarget(self, action: #selector(SubmitBookingRequestViewController.dateChanged(departuredatesubmit:)),for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SubmitBookingRequestViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        DepartureDate.inputView = departuredatesubmit
        
        returndatesubmit = UIDatePicker()
        returndatesubmit?.datePickerMode = .date
        returndatesubmit?.addTarget(self, action: #selector(SubmitBookingRequestViewController.dateChanged(returndatesubmit:)),for: .valueChanged)
        
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
