//
//  GeoNotificationDataTests.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-07.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import XCTest

@testable import RemoteGeofencing
class NotificationDataTests: XCTestCase {
    
    let notificationData = MockData()
    
    let dataKeys = GeoNotificationKeys.self
    
    
    
    var dataSet: [GeoNotification] = []
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_addNotification(){
        
        let data = notificationData.setData()
        dataSet.append(data)
        notificationData.addNotification(geoNotification: data)
        XCTAssertEqual(notificationData.geoNotifications.count, dataSet.count)
    }
    
    func test_saveGeoNotification(){
        let data = notificationData.setData()
        dataSet.append(data)
        notificationData.addNotification(geoNotification: data)
        notificationData.saveAllGeoNotifications()
        guard let savedItems = UserDefaults.standard.array(forKey: UserDefaultKeys.savedNotifications) else { return }
        XCTAssertEqual(savedItems.count, dataSet.count)
    }
    
    func test_updateNotification(){
        let data = notificationData.setData()
        dataSet.append(data)
        let indexInArray = dataSet.firstIndex(of: data)
        notificationData.addNotification(geoNotification: data)
        let status = "read"
        notificationData.updateGeoNotification(geoNotification: data, status: status)
        notificationData.loadAllGeoNotifications()
        let notificationStatus = notificationData.geoNotifications[indexInArray!].status
        let geo = dataSet[indexInArray!]
        geo.status = status
        dataSet[indexInArray!] = geo
        let newStatus = dataSet[indexInArray!].status
        XCTAssertEqual(notificationStatus, newStatus)
    }
    
    func test_removeAllNotifications(){
        let data = notificationData.setData()
        dataSet.append(data)
        notificationData.addNotification(geoNotification: data)
        notificationData.saveAllGeoNotifications()
        notificationData.removeAllNotifications()
        let savedItems = notificationData.geoNotifications
        dataSet.removeAll()
        XCTAssertEqual(savedItems.count, dataSet.count)
    }
    
    func test_removeNotification(){
        let data = notificationData.setData()
        dataSet.append(data)
        notificationData.addNotification(geoNotification: data)
        notificationData.saveAllGeoNotifications()
        notificationData.removeNotification(indexInArray: 0)
        let savedItems = notificationData.geoNotifications
        dataSet.remove(at: 0)
        XCTAssertEqual(savedItems.count, dataSet.count)
    }
}

extension NotificationDataTests{
    
    class MockData{
        
        var geoNotifications: [GeoNotification] = []
        
        let nIdentifier = NSUUID().uuidString
        let note = "Work"
        let eventType = EventType.onEntry
        let location = "Office"
        let status = "unread"
        
        func setData() -> GeoNotification {
            let data = GeoNotification(identifier: nIdentifier, note: note, eventType: eventType, location: location, status: status)
            return data
        }
        
        func addNotification(geoNotification: GeoNotification){
            geoNotifications.append(geoNotification)
        }
        
        func loadAllGeoNotifications(){
            let newGeo = geoNotifications
            geoNotifications = newGeo
        }
        
        func saveAllGeoNotifications(){
            let newGeo = geoNotifications
            geoNotifications = newGeo
        }
        
        func updateGeoNotification(geoNotification: GeoNotification, status: String){
            let indexInArray = geoNotifications.firstIndex(of: geoNotification)
            let geo = geoNotifications[indexInArray!]
            geo.status = status
            geoNotifications[indexInArray!] = geo
        }
        
        func removeNotification(indexInArray: Int){
            geoNotifications.remove(at: indexInArray)
        }
        
        func removeAllNotifications(){
            geoNotifications.removeAll()
            
        }
        
    }
    
}

