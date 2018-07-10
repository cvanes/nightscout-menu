//
//  UserConfiguration.swift
//  NightscoutMacMenuBar
//
//  Created by Chris van Es on 01/06/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation

class UserConfiguration {
    
    static let shared = UserConfiguration()
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var nightscoutUrl: String? {
        get {
            return userDefaults.string(forKey: "nightscoutUrl")
        }
        set {
            userDefaults.set(newValue, forKey: "nightscoutUrl")
        }
    }
    
    var preferredUnit: GlucoseEntryUnit {
        get {
            if let preferredUnit = userDefaults.string(forKey: "preferredUnit") {
                return GlucoseEntryUnit(rawValue: preferredUnit) ?? .mgdl
            }
            return .mgdl
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: "preferredUnit")
        }
    }
    
    var urgentHighThreshold: Double {
        get {
            return userDefaults.double(forKey: "urgentHighThreshold")
        }
        set {
            userDefaults.set(newValue, forKey: "urgentHighThreshold")
        }
    }
    
    var highThreshold: Double {
        get {
            return userDefaults.double(forKey: "highThreshold")
        }
        set {
            userDefaults.set(newValue, forKey: "highThreshold")
        }
    }
    
    var lowThreshold: Double {
        get {
            return userDefaults.double(forKey: "lowThreshold")
        }
        set {
            userDefaults.set(newValue, forKey: "lowThreshold")
        }
    }
    
    var urgentLowThreshold: Double {
        get {
            return userDefaults.double(forKey: "urgentLowThreshold")
        }
        set {
            userDefaults.set(newValue, forKey: "urgentLowThreshold")
        }
    }
    
    var showDelta: Bool {
        get {
            return userDefaults.object(forKey: "showDelta") as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: "showDelta")
        }
    }
    
    var showDirection: Bool {
        get {
            return userDefaults.object(forKey: "showDirection") as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: "showDirection")
        }
    }
    
    var showTime: Bool {
        get {
            return userDefaults.object(forKey: "showTime") as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: "showTime")
        }
    }
    
    var showUnit: Bool {
        get {
            return userDefaults.object(forKey: "showUnit") as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: "showUnit")
        }
    }
    
    var notifyUrgentHigh: Bool {
        get {
            return userDefaults.object(forKey: "notifyUrgentHigh") as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: "notifyUrgentHigh")
        }
    }
    
    var notifyHigh: Bool {
        get {
            return userDefaults.object(forKey: "notifyHigh") as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: "notifyHigh")
        }
    }
    
    var notifyLow: Bool {
        get {
            return userDefaults.object(forKey: "notifyLow") as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: "notifyLow")
        }
    }
    
    var notifyUrgentLow: Bool {
        get {
            return userDefaults.object(forKey: "notifyUrgentLow") as? Bool ?? true
        }
        set {
            userDefaults.set(newValue, forKey: "notifyUrgentLow")
        }
    }
    
}
