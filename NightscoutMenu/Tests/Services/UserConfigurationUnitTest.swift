//
//  UserConfigurationUnitTest.swift
//  NightscoutMenuTests
//
//  Created by Chris van Es on 10/07/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest

@testable import NightscoutMenu

class UserConfigurationUnitTest : XCTestCase {
    
    private let userDefaults = UserDefaultsMock()
    private var target: UserConfiguration!
    
    override func setUp() {
        target = UserConfiguration(userDefaults: userDefaults)
    }
    
    func testThatNightscoutUrlDefaultsToNil() {
        assertThat(target.nightscoutUrl, nilValue())
    }
    
    func testThatNightscoutUrlReturnedFromUserDefaults() {
        userDefaults.set("http://localhost:1234", forKey: "nightscoutUrl")
    
        assertThat(target.nightscoutUrl, presentAnd(equalTo("http://localhost:1234")))
    }
    
    func testThatNightscoutUrlStoredInUserDefaults() {
        target.nightscoutUrl = "http://localhost:4321"
        
        assertThat(userDefaults.string(forKey: "nightscoutUrl"), presentAnd(equalTo("http://localhost:4321")))
    }
    
    func testThatPreferredUnitDefaultsToMgdl() {
        assertThat(target.preferredUnit, equalTo(.mgdl))
    }
    
    func testThatPreferredUnitReturnedFromUserDefaults() {
        userDefaults.set("mmol", forKey: "preferredUnit")
        
        assertThat(target.preferredUnit, equalTo(.mmol))
    }
    
    func testThatPreferredUnitStoredInUserDefaults() {
        target.preferredUnit = .mmol
        
        assertThat(userDefaults.string(forKey: "preferredUnit"), presentAnd(equalTo("mmol")))
    }
    
    func testThatUrgentHighThresholdReturnedFromUserDefaults() {
        userDefaults.set(1, forKey: "urgentHighThreshold")
        
        assertThat(target.urgentHighThreshold, equalTo(1))
    }
    
    func testThatUrgentHighThresholdStoredInUserDefaults() {
        target.urgentHighThreshold = 2
        
        assertThat(userDefaults.double(forKey: "urgentHighThreshold"), equalTo(2))
    }
    
    func testThatHighThresholdReturnedFromUserDefaults() {
        userDefaults.set(1, forKey: "highThreshold")
        
        assertThat(target.highThreshold, equalTo(1))
    }
    
    func testThatHighThresholdStoredInUserDefaults() {
        target.highThreshold = 2
        
        assertThat(userDefaults.double(forKey: "highThreshold"), equalTo(2))
    }
    
    func testThatLowThresholdReturnedFromUserDefaults() {
        userDefaults.set(1, forKey: "lowThreshold")
        
        assertThat(target.lowThreshold, equalTo(1))
    }
    
    func testThatLowThresholdStoredInUserDefaults() {
        target.lowThreshold = 2
        
        assertThat(userDefaults.double(forKey: "lowThreshold"), equalTo(2))
    }
    
    func testThatUrgentLowThresholdReturnedFromUserDefaults() {
        userDefaults.set(1, forKey: "urgentLowThreshold")
        
        assertThat(target.urgentLowThreshold, equalTo(1))
    }
    
    func testThatUrgentLowThresholdStoredInUserDefaults() {
        target.urgentLowThreshold = 2
        
        assertThat(userDefaults.double(forKey: "urgentLowThreshold"), equalTo(2))
    }
    
    func testThatShowDeltaDefaultsToTrue() {
        assertThat(target.showDelta, equalTo(true))
    }
    
    func testThatShowDeltaReturnedFromUserDefaults() {
        userDefaults.set(true, forKey: "showDelta")
        
        assertThat(target.showDelta, equalTo(true))
    }
    
    func testThatShowDeltaStoredInUserDefaults() {
        target.showDelta = true
        
        assertThat(userDefaults.bool(forKey: "showDelta"), equalTo(true))
    }
    
    func testThatShowDirectionDefaultsToTrue() {
        assertThat(target.showDirection, equalTo(true))
    }
    
    func testThatShowDirectionReturnedFromUserDefaults() {
        userDefaults.set(true, forKey: "showDirection")
        
        assertThat(target.showDirection, equalTo(true))
    }
    
    func testThatShowDirectionStoredInUserDefaults() {
        target.showDirection = true
        
        assertThat(userDefaults.bool(forKey: "showDirection"), equalTo(true))
    }
    
    func testThatShowTimeDefaultsToTrue() {
        assertThat(target.showTime, equalTo(true))
    }
    
    func testThatShowTimeReturnedFromUserDefaults() {
        userDefaults.set(true, forKey: "showTime")
        
        assertThat(target.showTime, equalTo(true))
    }
    
    func testThatShowTimeStoredInUserDefaults() {
        target.showTime = true
        
        assertThat(userDefaults.bool(forKey: "showTime"), equalTo(true))
    }
    
    func testThatShowUnitDefaultsToTrue() {
        assertThat(target.showUnit, equalTo(true))
    }
    
    func testThatShowUnitReturnedFromUserDefaults() {
        userDefaults.set(true, forKey: "showUnit")
        
        assertThat(target.showUnit, equalTo(true))
    }
    
    func testThatShowUnitStoredInUserDefaults() {
        target.showUnit = true
        
        assertThat(userDefaults.bool(forKey: "showUnit"), equalTo(true))
    }
    
    func testThatNotifyUrgentHighDefaultsToTrue() {
        assertThat(target.notifyUrgentHigh, equalTo(true))
    }
    
    func testThatNotifyUrgentHighReturnedFromUserDefaults() {
        userDefaults.set(true, forKey: "notifyUrgentHigh")
        
        assertThat(target.notifyUrgentHigh, equalTo(true))
    }
    
    func testThatNotifyUrgentHighStoredInUserDefaults() {
        target.notifyUrgentHigh = true
        
        assertThat(userDefaults.bool(forKey: "notifyUrgentHigh"), equalTo(true))
    }
    
    func testThatNotifyHighDefaultsToTrue() {
        assertThat(target.notifyHigh, equalTo(true))
    }
    
    func testThatNotifyHighReturnedFromUserDefaults() {
        userDefaults.set(true, forKey: "notifyHigh")
        
        assertThat(target.notifyHigh, equalTo(true))
    }
    
    func testThatNotifyHighStoredInUserDefaults() {
        target.notifyHigh = true
        
        assertThat(userDefaults.bool(forKey: "notifyHigh"), equalTo(true))
    }
    
    func testThatNotifyLowDefaultsToTrue() {
        assertThat(target.notifyLow, equalTo(true))
    }
    
    func testThatNotifyLowReturnedFromUserDefaults() {
        userDefaults.set(true, forKey: "notifyLow")
        
        assertThat(target.notifyLow, equalTo(true))
    }
    
    func testThatNotifyLowStoredInUserDefaults() {
        target.notifyLow = true
        
        assertThat(userDefaults.bool(forKey: "notifyLow"), equalTo(true))
    }
    
    func testThatNotifyUrgentLowDefaultsToTrue() {
        assertThat(target.notifyUrgentLow, equalTo(true))
    }
    
    func testThatNotifyUrgentLowReturnedFromUserDefaults() {
        userDefaults.set(true, forKey: "notifyUrgentLow")
        
        assertThat(target.notifyUrgentLow, equalTo(true))
    }
    
    func testThatNotifyUrgentLowStoredInUserDefaults() {
        target.notifyUrgentLow = true
        
        assertThat(userDefaults.bool(forKey: "notifyUrgentLow"), equalTo(true))
    }
    
}
