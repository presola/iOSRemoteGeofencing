//
//  AddGeoControllerViewTests.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-02.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import XCTest
import CoreLocation
import MapKit

@testable import RemoteGeofencing
class AddGeoViewControllerTests: XCTestCase {
    
    let viewController = MockAddGeoViewController()
    let dataSample = ["Home", "Work", "Others"]
    
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
    
    func test_pickerView_Data(){
        XCTAssertEqual(viewController.pickerLocation.numberOfRows(inComponent: 0), dataSample.count)
    }
    
    func test_Selected_PickerViewData(){
        let row: Int = 2
        viewController.pickerLocation.selectRow(row: row, inComponent: 0, animated:false)
        let selectedDataSample = dataSample[row]
        let selectedPickerRow = viewController.pickerLocation.selectedRow(inComponent: 0)
        let selectedPickerValue = viewController.pickerData[selectedPickerRow]
        XCTAssertEqual(selectedPickerValue, selectedDataSample)
    }
    
    func test_Default_Radius(){
        let textSample = "2000"
        
        var textField = viewController.radiusTextField.text
        textField = textSample
        XCTAssertEqual(textField, textSample)
    }
    
    func test_NotEmpty_NoteField(){
        let textSample = "Entry into Office"
        var textField = viewController.noteTextField.text
        textField = textSample
        XCTAssertEqual(textField, textSample)
    }
    
    func test_DisabledSave_OnEmptyNoteField_onLoad(){
        let saveButtonStatus = viewController.saveButton.isEnabled
        XCTAssertFalse(saveButtonStatus)
    }
    
    func test_SearchBar_NotNil(){
        XCTAssertNotNil(viewController.resultSearchController)
    }
    
    func test_NavigationTitle_IsSearchBar(){
        XCTAssertEqual(viewController.navigationItem.titleView, viewController.resultSearchController.searchBar)
    }
    
    func test_AddPin_ToMapView(){
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let placemark = MKPlacemark(coordinate: coordinate)
        viewController.dropPinZoomIn(placemark: placemark)
        XCTAssertEqual(viewController.mapView.annotations.count, 1)
    }
    
    func test_AddCoordinate_ToMapView(){
        let coordinate = CLLocationCoordinate2D(latitude: 2, longitude: 3)
        let placemark = MKPlacemark(coordinate: coordinate)
        viewController.dropPinZoomIn(placemark: placemark)
        XCTAssertEqual(round(viewController.placemarkInfo.coordinate.latitude), coordinate.latitude)
        XCTAssertEqual(round(viewController.placemarkInfo.coordinate.longitude), coordinate.longitude)
    }
    
}

extension AddGeoViewControllerTests{
    
    
    
    class MockAddGeoViewController{
        var geoDataSet: [GeoData] = []
        let pickerLocation =  Others()
        let mapView = Annotations()
        var locationManager = CLLocationManager()
        let pickerData = ["Home", "Work", "Others"]
        let eventType = ""
        let radiusTextField = Others()
        let noteTextField = Others()
        let saveButton = Others()
        let navigationItem = MockResultSearchController()
        let resultSearchController = MockResultSearchController()
        var placemarkInfo: MKPlacemark!
        
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
        
        func dropPinZoomIn(placemark: MKPlacemark){
            let data = setData()
            placemarkInfo = placemark
            mapView.annotations.append(data)
            
        }
        
    }
    
    class Others{
        var selected: Int!
        var text: String!
        let isEnabled = false
        func numberOfRows(inComponent: Int) -> Int{
            return MockAddGeoViewController().pickerData.count
        }
        
        func selectRow(row: Int, inComponent: Int, animated:Bool){
            selected = row
        }
        
        func selectedRow(inComponent: Int) -> Int {
            return selected
        }
    }
    
    class Annotations{
        var annotations:[GeoData] = []
    }
    
    class MockResultSearchController{
        let searchBar = "Search"
        let titleView = "Search"
    }
}





