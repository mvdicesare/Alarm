//
//  SwitchTableViewCell.swift
//  myAlarm
//
//  Created by Michael Di Cesare on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
// step 1 of 5

protocol SettingTableViewCellDelegate: class {
func settingValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
}

class SwitchTableViewCell: UITableViewCell {

    var reciever: Alarm? {
        didSet {
            updateViews()
        }
    }
    // MARK: - IBO Outlets
    
    
    weak var delegate: SettingTableViewCellDelegate?
    
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    
    
    // MARK: - Actions
    
    @IBAction func alarmSwitchValueChanged(_ sender: UISwitch) {
        delegate?.settingValueChanged(self, selected: alarmSwitch.isOn)
        }
    
    func updateViews() {
        guard let alarm = reciever else {return}
        titleLabel.text = alarm.name
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.isOn
    }
}
