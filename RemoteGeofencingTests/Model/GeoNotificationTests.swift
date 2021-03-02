//
//  GeoNotificationTests.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-07.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import XCTest

@testable import RemoteGeofencing
class GeoNotificationTests: XCTestCase {
    
    let dataKeys = GeoNotificationKeys.self
    
    let identifier = NSUUID().uuidString
    let note = "Work"
    let eventType = EventType.onEntry
    let location = "Office"
    let status = "unread"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_GeoNotificationKeys_CodingKeysExists(){
        XCTAssertEqual(dataKeys.identifier, "identifier")
        XCTAssertEqual(dataKeys.note, "note")
        XCTAssertEqual(dataKeys.eventType, "eventType")
        XCTAssertEqual(dataKeys.location, "location")
        XCTAssertEqual(dataKeys.status, "status")
    }
    
    func test_GeoNotification_Init_WhenGivenInfos_SetsInfo(){
        let data =  setData()
        
        XCTAssertEqual(data.identifier, identifier)
        XCTAssertEqual(data.note, note)
        XCTAssertEqual(data.eventType, eventType)
        XCTAssertEqual(data.location, location)
        XCTAssertEqual(data.status, status)
    }
    
}

extension GeoNotificationTests{
    
    func setData() -> GeoNotification {
        let data = GeoNotification(identifier: identifier, note: note, eventType: eventType, location: location, status: status)
        return data
    }
}



