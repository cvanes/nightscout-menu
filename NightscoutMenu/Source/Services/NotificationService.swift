//
//  NotificationService.swift
//  NightscoutMacMenuBar
//
//  Created by Chris van Es on 03/06/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation
import AppKit
import RxSwift

class NotificationService : NSObject, NSUserNotificationCenterDelegate {
    
    static let shared = NotificationService()
    
    private let nightscoutService: NightscoutService
    private let userConfiguration: UserConfiguration
    private let notificationCenter: NSUserNotificationCenter
    
    init(nightscoutService: NightscoutService = .shared,
         userConfiguration: UserConfiguration = .shared,
         notificationCenter: NSUserNotificationCenter = .default) {
        self.nightscoutService = nightscoutService
        self.userConfiguration = userConfiguration
        self.notificationCenter = notificationCenter
        super.init()
        
        self.notificationCenter.delegate = self
        
        _ = nightscoutService.entries
            .sample(Observable<Int>.timer(900, period: 900, scheduler: MainScheduler.instance))
            .subscribe(onNext: alertUserIfOutsideTargetRange)
    }
    
    private func alertUserIfOutsideTargetRange(_ entries: [GlucoseEntry]) {
        if let entry = entries.first {
            if userConfiguration.notifyUrgentHigh && entry.value >= userConfiguration.urgentHighThreshold {
                notifyUrgentHigh(entry)
            } else if userConfiguration.notifyHigh && entry.value >= userConfiguration.highThreshold {
                notifyHigh(entry)
            } else if userConfiguration.notifyLow && entry.value <= userConfiguration.lowThreshold {
                notifyLow(entry)
            } else if userConfiguration.notifyUrgentLow && entry.value <= userConfiguration.urgentLowThreshold {
                notifyUrgentLow(entry)
            }
        }
    }
    
    private func notifyUrgentHigh(_ entry: GlucoseEntry) {
        presentNotification(message: String(format: "Urgent High: %0.1f %@", entry.value, entry.unit.rawValue))
    }
    
    private func notifyHigh(_ entry: GlucoseEntry) {
        presentNotification(message: String(format: "High: %0.1f %@", entry.value, entry.unit.rawValue))
    }
    
    private func notifyLow(_ entry: GlucoseEntry) {
        presentNotification(message: String(format: "Low: %0.1f %@", entry.value, entry.unit.rawValue))
    }
    
    private func notifyUrgentLow(_ entry: GlucoseEntry) {
        presentNotification(message: String(format: "Urgent Low: %0.1f %@", entry.value, entry.unit.rawValue))
    }
    
    private func presentNotification(message: String) {
        let notification = NSUserNotification()
        notification.title = "Nightscout"
        notification.subtitle = message
        notification.soundName = NSUserNotificationDefaultSoundName
        notificationCenter.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
}
