//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Michael Di Cesare on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    var reciever: Alarm?
    var alarmIsOn: Bool = true
      // MARK: - IBO Objects
    
    @IBOutlet weak var setDate: UIDatePicker!
    @IBOutlet weak var setTitleTextField: UITextField!
    @IBOutlet weak var setEnableButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            updateView()
          }
    
    // MARK: - IBO Actions
    
    @IBAction func savedButtonTapped(_ sender: Any) {
        guard let alarmText = setTitleTextField.text  else { return }
        if let alarm = reciever {
            AlarmController.shared.updateAlarm(alarm: alarm, enabled: alarmIsOn, fireDate: setDate.date, name: alarmText)
        } else {
            AlarmController.shared.addAlarm(name: alarmText, enabled: alarmIsOn, fireDate: setDate.date)
    }
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = reciever else { return }
        AlarmController.shared.toggle(alarm: alarm)
        alarmIsOn = alarm.isOn
        updateView()
    }
    
    private func updateView() {
        guard let alarm = reciever else { return }
        setDate.date = alarm.fireDate
        setTitleTextField.text = alarm.name
        
        setEnableButton.isHidden = false
        if alarm.isOn {
            setEnableButton.setTitle("Disable", for: UIControl.State.normal)
            setEnableButton.backgroundColor = .red
            setEnableButton.setTitleColor(.white, for: .normal  )
        } else {
            setEnableButton.setTitle("Enable", for: .normal)
            setEnableButton.backgroundColor = .cyan
            setEnableButton.setTitleColor(.black, for: .normal)
        }
    }

} // end of class



