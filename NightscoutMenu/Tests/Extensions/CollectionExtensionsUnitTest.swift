//
//  CollectionExtensionsUnitTest.swift
//  NightscoutMenu
//
//  Created by Chris van Es on 09/07/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest

@testable import NightscoutMenu

class CollectionExtenstionsUnitTest : XCTestCase {
    
    private let target = [1]
    
    func testThatValueReturnedWhenGettingElementAtIndex() {
        assertThat(target[safe: 0], presentAnd(equalTo(1)))
    }
    
    func testThatNilValueReturnedWhenGettingElementAtIndexOutOfBounds() {
        assertThat(target[safe: 1], nilValue())
    }
    
}
