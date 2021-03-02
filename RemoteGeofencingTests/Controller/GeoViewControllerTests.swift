//
//  GeotificationTests.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-11-30.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import XCTest

@testable import RemoteGeofencing
import CoreLocation
import MapKit

class GeoViewControllerTests: XCTestCase {
    
    let viewController = MockGeoViewController()
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Init_MapViewAfterViewDidLoad_IsNotNil(){
        XCTAssertNotNil(viewController.mapView)
    }
    
    func test_Init_LocationManager_IsNotNil(){
        XCTAssertNotNil(viewController.locationManager)
    }
    
    
    func test_LoadAllAddedGeoData_OnViewDidLoad(){
        let geoData = loadData()
        viewController.geoDataSet = geoData
        viewController.saveAllGeoData()
        viewController.loadAllGeoData()
        XCTAssertEqual(viewController.geoDataSet.index(after: 0), geoData.index(before: 2))
        XCTAssertEqual(viewController.geoDataSet.count, geoData.count)
        viewController.removeAll()
    }
    
    
    func test_UpdateGeoDataCount_AfterAdd(){
        let initialCount = viewController.geoDataSet.count
        let geoData = loadData()
        viewController.geoDataSet = geoData
        viewController.saveAllGeoData()
        viewController.loadAllGeoData()
        XCTAssertNotEqual(viewController.geoDataSet.count, initialCount)
        viewController.removeAll()
    }
    
    func test_MapViewUpdateAnnotations_AfterAdd(){
        let geoData = loadData()
        viewController.geoDataSet = geoData
        viewController.saveAllGeoData()
        viewController.loadAllGeoData()
        XCTAssertEqual(viewController.mapView.annotations.count, geoData.count)
        viewController.removeAll()
    }
    
    func test_AddRadius_AfterAdd(){
        let geoData = setData()
        viewController.add(geoData: geoData)
        XCTAssertEqual(getRadius(), geoData.radius)
    }
    
    func test_MapViewUpdateAnnotations_AfterDeleteOne(){
        let geoData = setData()
        let geoDataSet = loadData()
        viewController.geoDataSet = geoDataSet
        viewController.saveAllGeoData()
        viewController.loadAllGeoData()
        viewController.remove(geoData: geoData)
        XCTAssertEqual(viewController.mapView.annotations.count, geoDataSet.count)
    }
    
    func test_MapViewUpdateAnnotations_AfterDeleteAll(){
        let geoData = loadData()
        viewController.geoDataSet = geoData
        viewController.saveAllGeoData()
        viewController.loadAllGeoData()
        viewController.removeAll()
        XCTAssertNotEqual(viewController.mapView.annotations.count, geoData.count)
    }
}

extension GeoViewControllerTests{
    func setData() -> GeoData {
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        
        let radius = Double(100)
        let identifier = NSUUID().uuidString
        let note = "Work"
        let eventType = EventType.onEntry
        let location = "Office"
        let status = "Unread"
        let data = GeoData(coordinate: coordinate, radius: radius, identifier: identifier, note: note, eventType: eventType, location: location, status: status)
        return data
    }
    
    func loadData() -> [GeoData]{
        var geoData: [GeoData] = []
        geoData.append(setData())
        return geoData
    }
    
    func getRadius() -> Double{
        return 100
        
    }
}

extension GeoViewControllerTests{
    
    class MockGeoViewController{
        var geoDataSet: [GeoData] = []
        let mapView =  Annotations()
        var locationManager = CLLocationManager()
        
        func add(geoData: GeoData){
            geoDataSet.append(geoData)
            mapView.annotations.append(geoData)
        }
        
        func loadAllGeoData(){
            let existingData = geoDataSet
            geoDataSet = existingData
            mapView.annotations = geoDataSet
        }
        
        func saveAllGeoData(){
            let existingData = geoDataSet
            geoDataSet = existingData
        }
        
        func remove(geoData: GeoData){
            if let indexInArray = geoDataSet.firstIndex(of: geoData) {
                geoDataSet.remove(at: indexInArray)
                mapView.annotations.remove(at: indexInArray)
            }
        }
        
        func removeAll(){
            geoDataSet.removeAll()
            mapView.annotations.removeAll()
        }
        
    }
    
    class Annotations{
        var annotations:[GeoData] = []
    }
}


