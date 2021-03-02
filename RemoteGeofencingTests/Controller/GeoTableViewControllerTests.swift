//
//  GeoTableViewControllerTests.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-02.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import XCTest

@testable import RemoteGeofencing
class GeoTableViewControllerTests: XCTestCase {
    
    var viewController: GeoTableViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        viewController = (storyboard.instantiateViewController(withIdentifier: "GeoTableViewController") as! GeoTableViewController)
        
        _ = viewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_numberOfTableSections(){
        
    }
}
