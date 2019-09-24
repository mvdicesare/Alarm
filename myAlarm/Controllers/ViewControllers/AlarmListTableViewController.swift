//
//  AlarmListTableViewController.swift
//  myAlarm
//
//  Created by Michael Di Cesare on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    var alarm: [Alarm?] = []
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.shared.alarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell?.reciever = alarm
        cell?.delegate = self

        // Configure the cell...

        return cell ?? UITableViewCell()
    }
    

 
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.deleteAlarm(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmSetting"{
            guard let destination = segue.destination as? AlarmDetailTableViewController,
                let index = tableView.indexPathForSelectedRow else { return }
            let tappedOnEntry = AlarmController.shared.alarms[index.row]
            destination.reciever = tappedOnEntry
            
        }
    }
}

extension AlarmListTableViewController: SettingTableViewCellDelegate {
    func settingValueChanged(_ cell: SwitchTableViewCell, selected: Bool) {
        guard let alarm = cell.reciever else { return }
        AlarmController.shared.toggle(alarm: alarm)
        cell.updateViews()
    }
}
