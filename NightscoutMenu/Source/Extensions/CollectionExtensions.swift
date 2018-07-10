//
//  CollectionExtensions.swift
//  NightscoutMacMenuBar
//
//  Created by Chris van Es on 03/06/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
