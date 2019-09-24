//
//  Alarm.swift
//  myAlarm
//
//  Created by Michael Di Cesare on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

let currentTime = Date()
    
    //Calendar.current.dateComponents(in: .autoupdatingCurrent, from: Date()).hour!



class Alarm: Codable {
    
    var name: String?
    var isOn: Bool
    var fireDate: Date
    var uuid: String
    var fireTimeAsString: String {
        let newDateFormatter = DateFormatter()
        newDateFormatter.timeStyle = .short
        newDateFormatter.dateFormat = .none
        let stringOfTime = newDateFormatter.string(from: fireDate)
        return stringOfTime
        
    }
    
    init(name: String?, enabled: Bool = true, fireDate: Date, uuid: String = UUID().uuidString ) {
        self.name = name
        self.isOn = enabled
        self.fireDate = fireDate
        self.uuid = uuid
    }
}

extension Alarm: Equatable {
static func == (lhs: Alarm, rhs: Alarm) -> Bool {
    if lhs.name != rhs.name { return false }
    if lhs.isOn != rhs.isOn { return false }
    if lhs.fireDate != rhs.fireDate { return false }
    if lhs.uuid != rhs.uuid { return false }

    return true
}

}
