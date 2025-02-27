//
//  AppDelegate.swift
//  myAlarm
//
//  Created by DevMountain on 8/25/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AlarmController.shared.loadFromPersistentStore()
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//            if let error = error {
//            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//            }
//        }
        
     //   AlarmController.shared.alarms = AlarmController.shared.loadFromPersisentStore()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (accepted, error) in
            if !accepted{
                print("Notification access has been denied")
            }
        }

        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

}

