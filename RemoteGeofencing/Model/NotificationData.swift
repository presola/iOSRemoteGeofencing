//
//  NotificationData.swift
//  Geofencing
//
//  Created by Abisola Adeniran on 2016-12-07.
//  Copyright © 2016 Abisola Adeniran. All rights reserved.
//

import UIKit

class NotificationData{
    
    var geoNotifications: [GeoNotification] = []
    
    func addNotification(geoNotification: GeoNotification){
        self.geoNotifications.append(geoNotification)
        saveAllGeoNotifications()
    }
    
    func loadAllGeoNotifications(){
        geoNotifications = []
        guard let savedItems = UserDefaults.standard.array(forKey: UserDefaultKeys.savedNotifications) else { return }
        for savedItem in savedItems {
            guard let geoNotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? GeoNotification else { continue }
            addNotification(geoNotification: geoNotification)
        }
    }
    
    func saveAllGeoNotifications() {
        var items: [Data] = []
        for geoNotification in geoNotifications {
            let item = NSKeyedArchiver.archivedData(withRootObject: geoNotification)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: UserDefaultKeys.savedNotifications)
    }
    
    
    func updateGeoNotification(geoNotification: GeoNotification, status: String){
        let indexInArray = geoNotifications.index(of: geoNotification)
        let geo = geoNotifications[indexInArray!]
        geo.status = status
        geoNotifications[indexInArray!] = geo
        saveAllGeoNotifications()
    }
    
    func removeNotification(indexInArray: Int){
        geoNotifications.remove(at: indexInArray)
        saveAllGeoNotifications()
    }
    
    func removeAllNotifications(){
        geoNotifications.removeAll()
        saveAllGeoNotifications()
    }
}
