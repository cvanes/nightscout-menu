//
//  UserDefaultsMock.swift
//  NightscoutMenuTests
//
//  Created by Chris van Es on 10/07/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation

class UserDefaultsMock : UserDefaults {
    
    convenience init() {
        self.init(suiteName: "User Defaults Mock")!
    }
    
    override init?(suiteName suitename: String?) {
        super.init(suiteName: suitename)
        removePersistentDomain(forName: suitename!)
    }
    
}
