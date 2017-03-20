//
//  GeoNotifications.swift
//  Geofencing
//
//  Created by Abisola Adeniran on 2016-11-30.
//  Copyright © 2016 Abisola Adeniran. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

struct GeoNotificationKeys {
    static let identifier = "identifier"
    static let note = "note"
    static let eventType = "eventType"
    static let location = "location"
    static let status = "status"
}

class GeoNotification: NSObject, NSCoding {
    
    var identifier: String
    var note: String
    var eventType: EventType
    var location: String
    var status: String
    
    
    init(identifier: String, note: String, eventType: EventType, location: String, status: String) {
        self.identifier = identifier
        self.note = note
        self.eventType = eventType
        self.location = location
        self.status = status
    }
    
    
    //required for NSCoding
    required init?(coder decoder: NSCoder) {
        identifier = decoder.decodeObject(forKey: GeoDataKeys.identifier) as! String
        note = decoder.decodeObject(forKey: GeoDataKeys.note) as! String
        eventType = EventType(rawValue: decoder.decodeObject(forKey: GeoDataKeys.eventType) as! String)!
        location = decoder.decodeObject(forKey: GeoDataKeys.location) as! String
        status = decoder.decodeObject(forKey: GeoDataKeys.status) as! String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(identifier, forKey: GeoDataKeys.identifier)
        coder.encode(note, forKey: GeoDataKeys.note)
        coder.encode(eventType.rawValue, forKey: GeoDataKeys.eventType)
        coder.encode(location, forKey: GeoDataKeys.location)
        coder.encode(status, forKey: GeoDataKeys.status)
    }
}
