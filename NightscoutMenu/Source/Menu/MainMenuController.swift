//
//  MainMenuController.swift
//  NightscoutMacMenuBar
//
//  Created by Chris van Es on 01/06/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Cocoa
import RxSwift

class MainMenuController : NSObject {
    
    @IBOutlet private var topMenu: NSMenu!
    @IBOutlet private var lastUpdatedMenuItem: NSMenuItem!
    @IBOutlet private var historyMenu: NSMenu!
    @IBOutlet private var showDeltaMenuItem: NSMenuItem!
    @IBOutlet private var showDirectionMenuItem: NSMenuItem!
    @IBOutlet private var showTimeMenuItem: NSMenuItem!
    @IBOutlet private var showUnitMenuItem: NSMenuItem!
    @IBOutlet private var notifyUrgentHighMenuItem: NSMenuItem!
    @IBOutlet private var notifyHighMenuItem: NSMenuItem!
    @IBOutlet private var notifyLowMenuItem: NSMenuItem!
    @IBOutlet private var notifyUrgentLowMenuItem: NSMenuItem!
    
    private let userConfiguration = UserConfiguration.shared
    private let nightscoutService = NightscoutService.shared
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mm"
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        statusBarItem.title = "Nightscout Menu"
        statusBarItem.menu = topMenu
        showDeltaMenuItem.isOn = userConfiguration.showDelta
        showDirectionMenuItem.isOn = userConfiguration.showDirection
        showTimeMenuItem.isOn = userConfiguration.showTime
        showUnitMenuItem.isOn = userConfiguration.showUnit
        notifyUrgentHighMenuItem.isOn = userConfiguration.notifyUrgentHigh
        notifyHighMenuItem.isOn = userConfiguration.notifyHigh
        notifyLowMenuItem.isOn = userConfiguration.notifyLow
        notifyUrgentLowMenuItem.isOn = userConfiguration.notifyUrgentLow
        
        _ = nightscoutService.entries.subscribe(onNext: reloadEntries)
    }
    
    private func reloadEntries() {
        let entries = (try? nightscoutService.entries.value()) ?? []
        reloadEntries(entries)
    }
    
    private func reloadEntries(_ entries: [GlucoseEntry]) {
        if let entry = entries.first {
            statusBarItem.title = formatEntry(entry, nextEntry: entries[1])
            lastUpdatedMenuItem.title = "Updated \(dateFormatter.string(from: entry.timestamp))"
        }
        
        historyMenu.removeAllItems()
        let historicalEntries = entries.dropFirst()
        for (index, entry) in historicalEntries.enumerated() {
            let menuItem = NSMenuItem(title: formatEntry(entry, nextEntry: historicalEntries[safe: index + 2]), action: nil, keyEquivalent: "")
            historyMenu.addItem(menuItem)
        }
    }
    
    private func formatEntry(_ entry: GlucoseEntry, nextEntry: GlucoseEntry?) -> String {
        let value = String(format: "%.1f ", entry.value)
        let delta = userConfiguration.showDelta ? "(\(calculateDelta(entry, nextEntry))) " : ""
        let unit = userConfiguration.showUnit ? "\(userConfiguration.preferredUnit.rawValue) " : ""
        let direction = userConfiguration.showDirection ? "\(entry.direction.symbol) " : ""
        let time = userConfiguration.showTime ? String(format: "(%.0fm ago)", Date().timeIntervalSince(entry.timestamp) / 60) : ""
        
        return "\(value)\(delta)\(unit)\(direction)\(time)"
    }
    
    private func calculateDelta(_ entry: GlucoseEntry, _ nextEntry: GlucoseEntry?) -> String {
        let delta = entry.value - (nextEntry?.value ?? entry.value)
        let prefix = delta > 0 ? "+" : ""
        return String(format: "\(prefix)%.1f", delta)
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func setNightscoutUrl(_ sender: Any) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "Nightscout Configuration"
        alert.informativeText = "Enter your Nightscout URL below."
        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 320, height: 22))
        textField.stringValue = userConfiguration.nightscoutUrl ?? ""
        alert.accessoryView = textField
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle:"Cancel")
        
        let response = alert.runModal()
        guard response == .alertFirstButtonReturn else {
            return
        }
        
        let nightscoutUrl = textField.stringValue.trimmingCharacters(in: .whitespaces)
        nightscoutService.updateUrl(nightscoutUrl)
    }
    
    @IBAction func openNightscout(_ sender: Any) {
        if let nightscoutUrlString = userConfiguration.nightscoutUrl, let nightscoutUrl = URL(string: nightscoutUrlString) {
            NSWorkspace.shared.open(nightscoutUrl)
        }
    }
    
    @IBAction func toggleShowDelta(_ sender: NSMenuItem) {
        userConfiguration.showDelta = !userConfiguration.showDelta
        sender.isOn = userConfiguration.showDelta
        reloadEntries()
    }
    
    @IBAction func toggleShowTime(_ sender: NSMenuItem) {
        userConfiguration.showTime = !userConfiguration.showTime
        sender.isOn = userConfiguration.showTime
        reloadEntries()
    }
    
    @IBAction func toggleShowDirection(_ sender: NSMenuItem) {
        userConfiguration.showDirection = !userConfiguration.showDirection
        sender.isOn = userConfiguration.showDirection
        reloadEntries()
    }
    
    @IBAction func toggleShowUnit(_ sender: NSMenuItem) {
        userConfiguration.showUnit = !userConfiguration.showUnit
        sender.isOn = userConfiguration.showUnit
        reloadEntries()
    }
    
    @IBAction func toggleUrgentHighNotification(_ sender: NSMenuItem) {
        userConfiguration.notifyUrgentHigh = !userConfiguration.notifyUrgentHigh
        sender.isOn = userConfiguration.notifyUrgentHigh
    }
    
    @IBAction func toggleHighNotification(_ sender: NSMenuItem) {
        userConfiguration.notifyHigh = !userConfiguration.notifyHigh
        sender.isOn = userConfiguration.notifyHigh
    }
    
    @IBAction func toggleLowNotification(_ sender: NSMenuItem) {
        userConfiguration.notifyLow = !userConfiguration.notifyLow
        sender.isOn = userConfiguration.notifyLow
    }
    
    @IBAction func toggleUrgentLowNotification(_ sender: NSMenuItem) {
        userConfiguration.notifyUrgentLow = !userConfiguration.notifyUrgentLow
        sender.isOn = userConfiguration.notifyUrgentLow
    }
    
}
