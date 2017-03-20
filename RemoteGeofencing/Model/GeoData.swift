//
//  GeoData.swift
//  Geofencing
//
//  Created by Abisola Adeniran on 2016-11-30.
//  Copyright © 2016 Abisola Adeniran. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

struct GeoDataKeys {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let radius = "radius"
    static let identifier = "identifier"
    static let note = "note"
    static let eventType = "eventType"
    static let location = "location"
    static let status = "status"
}

class GeoData: NSObject, NSCoding, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var note: String
    var eventType: EventType
    var location: String
    var status: String
    
    
    var title: String? {
        if note.isEmpty {
            return "No Note"
        }
        return note
    }
    
    var subtitle: String? {
        let eventTypeString = eventType.rawValue
        return "Radius: \(radius)m - \(eventTypeString)"
    }
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType, location: String, status: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.note = note
        self.eventType = eventType
        self.location = location
        self.status = status
    }
    
    
    //required for NSCoding
    required init?(coder decoder: NSCoder) {
        let latitude = decoder.decodeDouble(forKey: GeoDataKeys.latitude)
        let longitude = decoder.decodeDouble(forKey: GeoDataKeys.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDouble(forKey: GeoDataKeys.radius)
        identifier = decoder.decodeObject(forKey: GeoDataKeys.identifier) as! String
        note = decoder.decodeObject(forKey: GeoDataKeys.note) as! String
        eventType = EventType(rawValue: decoder.decodeObject(forKey: GeoDataKeys.eventType) as! String)!
        location = decoder.decodeObject(forKey: GeoDataKeys.location) as! String
        status = decoder.decodeObject(forKey: GeoDataKeys.status) as! String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: GeoDataKeys.latitude)
        coder.encode(coordinate.longitude, forKey: GeoDataKeys.longitude)
        coder.encode(radius, forKey: GeoDataKeys.radius)
        coder.encode(identifier, forKey: GeoDataKeys.identifier)
        coder.encode(note, forKey: GeoDataKeys.note)
        coder.encode(eventType.rawValue, forKey: GeoDataKeys.eventType)
        coder.encode(location, forKey: GeoDataKeys.location)
        coder.encode(status, forKey: GeoDataKeys.status)
    }
}

enum EventType: String {
    case onEntry = "On Entry"
    case onExit = "On Exit"
}

struct UserDefaultKeys {
    static let savedData = "savedData"
    static let savedNotifications = "savedNotifications"
}

