//
//  AlarmController.swift
//  myAlarm
//
//  Created by Michael Di Cesare on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UserNotifications



class AlarmController: AlarmScheduler {
      
    
    static let shared = AlarmController()
    
    var alarms: [Alarm] = []
    
    func addAlarm(name: String, enabled: Bool, fireDate: Date) {
     let newAlarm = Alarm(name: name, enabled: enabled, fireDate: fireDate)
        alarms.append(newAlarm)
        scheduleUserNotification(for: newAlarm)
        saveToPersistentStore()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard alarms.firstIndex(of: alarm) != nil else { return }
        saveToPersistentStore()
        cancelUserNotification(for: alarm)
    }
    
    func toggle(alarm: Alarm) {
        alarm.isOn = !alarm.isOn
        if alarm.isOn {
        scheduleUserNotification(for: alarm)
        } else {
        cancelUserNotification(for: alarm)
        }
        
        saveToPersistentStore()
    }
    
    func updateAlarm(alarm: Alarm, enabled: Bool, fireDate: Date, name: String) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.isOn = enabled
        saveToPersistentStore()
    }

// MARK: - Save: 
    func createFuleURLForPersistence() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let fileURL = urls[0].appendingPathComponent("Alarm.json") // *** CHANGE FILE NAME HERE ***
        
        return fileURL
    }
    
    
    func saveToPersistentStore() {
        // Creating an instance of the JSONEncoder class
        let jsonEncoder = JSONEncoder()
        
        do {
            // Access the JSONEncoder class to encode our Source of Truth and turn it tnto JSON
            let crayonJSON = try jsonEncoder.encode(alarms)
            // Write that JSON to our fileURL for local storage
            try crayonJSON.write(to: createFuleURLForPersistence())
        } catch {
            // IF THAT FAILS, we catch the error
            print("Error encoding alarm: \(error.localizedDescription) \n ----- \n \(error)")
        }
    }
    
    
    func loadFromPersistentStore() {
        
        let jsonDecoder = JSONDecoder()
        
        do {
            // attempt to find file
            let jsonData = try Data(contentsOf: createFuleURLForPersistence())
            
            let decodedCrayons = try jsonDecoder.decode([Alarm].self, from: jsonData)
            
            // update source of truth with decoded crayons
            alarms = decodedCrayons
            
            // catch errors
        } catch {
            print("Error decoding Crayons: \(error.localizedDescription) \n ----- \n \(error)")
        }
    }


} // end of class
// MARK: - Protocal:
protocol AlarmScheduler: class {
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotification(for alarm: Alarm)
}


// MARK: - Extention and Alert Controller:

extension AlarmScheduler {

func scheduleUserNotification(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "MOVE IT!"
        notificationContent.body = "It is time to go"
        notificationContent.sound = .default()
       
    let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
    let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
    let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: notificationTrigger)
    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func cancelUserNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
} // end
