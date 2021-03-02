//
//  GeoData.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-11-30.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import XCTest

@testable import RemoteGeofencing
import CoreLocation

class GeoDataTests: XCTestCase {
    
    let dataKeys = GeoDataKeys.self
    
    let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
    
    let radius = Double(100)
    let identifier = NSUUID().uuidString
    let note = "Work"
    let eventType = EventType.onEntry
    let location = "Office"
    let status = "unread"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //data = GeoData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_GeoDataKeys_CodingKeysExists(){
        XCTAssertEqual(dataKeys.latitude, "latitude")
        XCTAssertEqual(dataKeys.longitude, "longitude")
        XCTAssertEqual(dataKeys.radius, "radius")
        XCTAssertEqual(dataKeys.identifier, "identifier")
        XCTAssertEqual(dataKeys.note, "note")
        XCTAssertEqual(dataKeys.eventType, "eventType")
        XCTAssertEqual(dataKeys.location, "location")
        XCTAssertEqual(dataKeys.status, "status")
    }
    
    func test_GeoData_Init_WhenGivenCoordinate_SetsCoordinate(){
        let data =  setData()
        
        XCTAssertEqual(data.coordinate.latitude, coordinate.latitude)
        XCTAssertEqual(data.coordinate.longitude, coordinate.longitude)
        XCTAssertEqual(data.radius, radius)
        XCTAssertEqual(data.identifier, identifier)
        XCTAssertEqual(data.note, note)
        XCTAssertEqual(data.eventType, eventType)
        XCTAssertEqual(data.location, location)
        XCTAssertEqual(data.status, status)
    }
    
}

extension GeoDataTests{
    
    func setData() -> GeoData {
        let data = GeoData(coordinate: coordinate, radius: radius, identifier: identifier, note: note, eventType: eventType, location: location, status: status)
        return data
    }
}

