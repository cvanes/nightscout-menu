//
//  NightscoutService.swift
//  NightscoutMacMenuBar
//
//  Created by Chris van Es on 01/06/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation
import RxSwift

class NightscoutService {
    
    static let shared = NightscoutService()
    
    let entries = BehaviorSubject(value: [GlucoseEntry]())
    
    private let apiClient: NightscoutApiClient
    private let userConfiguration: UserConfiguration
    private let ioScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    private var fetchEntriesSubscription: Disposable?
    
    init(apiClient: NightscoutApiClient = .shared, userConfiguration: UserConfiguration = .shared) {
        self.apiClient = apiClient
        self.userConfiguration = userConfiguration
        
        observePowerStateChangeEvents()
    }
    
    private func observePowerStateChangeEvents() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: nil) { [weak self] _ in
            self?.fetchEntriesSubscription?.dispose()
            self?.fetchEntriesSubscription = nil
        }
        notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: nil) { [weak self] _ in
            self?.fetchEntries()
        }
    }
    
    func updateUrl(_ nightscoutUrl: String) {
        userConfiguration.nightscoutUrl = nightscoutUrl
        
        _ = apiClient.fetchSettings()
            .subscribeOn(ioScheduler)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onSuccess: successfullyFetchedSettings, onError: failedToFetchSettings)
    }
    
    private func successfullyFetchedSettings(settings: Settings) {
        userConfiguration.preferredUnit = settings.preferredUnit
        userConfiguration.urgentHighThreshold = settings.thresholds.urgentHigh
        userConfiguration.highThreshold = settings.thresholds.high
        userConfiguration.lowThreshold = settings.thresholds.low
        userConfiguration.urgentLowThreshold = settings.thresholds.urgentLow
        
        fetchEntries()
    }
    
    private func failedToFetchSettings(error: Error) {
        NSLog("Failed to fetch settings:\(error)")
        presentError(message: "Failed to fetch Nightscout configuration, please check the configured URL")
    }
    
    private func fetchEntries() {
        guard userConfiguration.nightscoutUrl != nil else { return }
        
        _ = apiClient.fetchEntries()
            .subscribeOn(ioScheduler)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onSuccess: entries.onNext, onError: failedToGetEntries)
        
        fetchEntriesSubscription?.dispose()
        fetchEntriesSubscription = Observable<Int>.interval(60, scheduler: ioScheduler)
            .flatMap { _ in return self.apiClient.fetchEntries().asObservable() }
            .subscribeOn(ioScheduler)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: entries.onNext, onError: failedToGetEntries)
    }
    
    private func failedToGetEntries(error: Error) {
        NSLog("Failed to get entries: \(error)")
        presentError(message: "Failed to get entries from Nightscout")
    }
    
    private func presentError(message: String) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Nightscout Error"
        alert.informativeText = message
        alert.runModal()
    }
    
}
