//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Artur Balabanskyy on 1/2/18.
//  Copyright © 2018 Artur Balabanskyy. All rights reserved.
//

import UIKit

class HMAddRegistrationTableViewController: UITableViewController, HMRoomTypeTableViewControllerDelegate {

    let defaultCellHeight: CGFloat = 44.0
    let defaultPickerCellHeight: CGFloat = 220.0
    let hiddenPickerCellHeight: CGFloat = 0.0
    
    let checkInInfoCellIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutInfoCellIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerShown: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    
    var isCheckOutDatePickerShown: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var wifiPriceLabel: UILabel!
    @IBOutlet weak var wifiSwitcher: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    var roomType: HMRoomType?
    
    var registration: HMRegistration? {
        
        guard let roomType = roomType else { return nil }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitcher.isOn
        
        return HMRegistration(firstName: firstName, lastName: lastName, email: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, wifi: hasWifi, roomType: roomType)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        
        updateDateViews()
        updateNumberOfGuests()
        updateWiFiPrice()
        updateRoomType()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectTypeSegue" {
            let destination = segue.destination as? HMRoomTypeTableViewController
            destination?.delegate = self
            destination?.roomType = roomType
        }
    }

    
    
    @IBAction func doneBarButtonTapped(_ sender: Any) {
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitcher.isOn
        
        print("Done")
        print("First name: \(firstName)")
        print("Last name: \(lastName)")
        print("Email: \(email)")
        print("Check In: \(checkInDate)")
        print("Check Out: \(checkOutDate)")
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(24 * 60 * 60) //86400
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section, indexPath.row) {
        case (checkInDatePickerIndexPath.section, checkInDatePickerIndexPath.row):
            if isCheckInDatePickerShown {
                return defaultPickerCellHeight //220.0
            }
            else {
                return hiddenPickerCellHeight //0.0
            }
        case (checkOutDatePickerIndexPath.section, checkOutDatePickerIndexPath.row):
            if isCheckOutDatePickerShown {
                return defaultPickerCellHeight //220.0
            }
            else {
                return hiddenPickerCellHeight //0.0
            }
        default:
            return defaultCellHeight // 44.0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (checkInInfoCellIndexPath.section, checkInInfoCellIndexPath.row):
            if isCheckInDatePickerShown {
                isCheckInDatePickerShown = false
            }
            else if isCheckOutDatePickerShown {
                isCheckOutDatePickerShown = false
                isCheckInDatePickerShown = true
            }
            else {
                isCheckInDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (checkOutInfoCellIndexPath.section, checkOutInfoCellIndexPath.row):
            if isCheckOutDatePickerShown {
                isCheckOutDatePickerShown = false
            }
            else if isCheckInDatePickerShown {
                isCheckInDatePickerShown = false
                isCheckOutDatePickerShown = true
            }
            else {
                isCheckOutDatePickerShown = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
        
    }
    @IBAction func stepperValueChanger(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
        
    }
    
    @IBAction func wifiSwitcherValueChanged(_ sender: UISwitch) {
        updateWiFiPrice()
    }
    
    func updateWiFiPrice() {
        wifiPriceLabel.text = wifiSwitcher.isOn ? "$10" : "$0"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.shortName
        }
        else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    
    
    //MARK: - HMRoomTypeTableViewControllerDelegate
    
    func didSelect(roomType: HMRoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
    
}
