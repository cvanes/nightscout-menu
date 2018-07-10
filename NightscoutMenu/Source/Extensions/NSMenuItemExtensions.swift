//
//  NSMenuItemExtensions.swift
//  NightscoutMacMenuBar
//
//  Created by Chris van Es on 03/06/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation
import Cocoa

extension NSMenuItem {
    
    var isOn: Bool {
        get {
            return state == .on
        }
        set {
            state = newValue ? .on : .off
        }
    }
    
}
