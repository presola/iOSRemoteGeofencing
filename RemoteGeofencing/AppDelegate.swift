//
//  AppDelegate.swift
//  RemoteGeofencing
//
//  Created by Abisola Adeniran on 2016-11-30.
//  Copyright © 2016 Abisola Adeniran. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    let locationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    
    var geoNotifications: [GeoNotification] = []
    let notificationData = NotificationData()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let badgeView = UIApplication.topViewController()?.tabBarController?.tabBar.items![2]
        loadData()
        badgeView?.badgeValue = "\(geoNotifications.count)"
        UIApplication.shared.applicationIconBadgeNumber = geoNotifications.count
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let badgeView = UIApplication.topViewController()?.tabBarController?.tabBar.items![2]
        loadData()
        badgeView?.badgeValue = "\(geoNotifications.count)"
        UIApplication.shared.applicationIconBadgeNumber = geoNotifications.count

    }
}
extension AppDelegate{
    
    func geoData(fromRegionIdentifier identifier: String) -> GeoData? {
        let savedItems = UserDefaults.standard.array(forKey: UserDefaultKeys.savedData) as? [NSData]
        let geoData = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? GeoData }
        let index = geoData?.index { $0?.identifier == identifier }
        return index != nil ? geoData?[index!] : nil
    }
    
    func note(fromRegionIdentifier identifier: String) -> String? {
        let savedItems = UserDefaults.standard.array(forKey: UserDefaultKeys.savedData) as? [NSData]
        let geoData = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? GeoData }
        let index = geoData?.index { $0?.identifier == identifier }
        return index != nil ? geoData?[index!]?.note : nil
    }
    
    func location(fromRegionIdentifier identifier: String) -> String? {
        let savedItems = UserDefaults.standard.array(forKey: UserDefaultKeys.savedData) as? [NSData]
        let geoData = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? GeoData }
        let index = geoData?.index { $0?.identifier == identifier }
        let locationType = index != nil ? geoData?[index!]?.location : nil
        var imageName: String? {
            var imageValue: String
            if locationType == "Work" {
                imageValue = "work"
                return imageValue
            }
            else if locationType == "Home" {
                imageValue = "home"
                return imageValue
            }
            else {
                imageValue = "others"
                return imageValue
            }
        }
        return imageName
    }
    
    func addNotification(forRegion region: CLRegion!){
        guard let geoData = geoData(fromRegionIdentifier: region.identifier) else { return }
        let geoNotification = GeoNotification(identifier: geoData.identifier, note: geoData.note, eventType: geoData.eventType, location: geoData.location, status: geoData.status)
//        geoNotifications.append(geoNotification)
//
//        notificationData.geoNotifications = geoNotifications
        notificationData.addNotification(geoNotification: geoNotification)
        notificationData.saveAllGeoNotifications()
    }
    
    func triggerNotification(forRegion region: CLRegion!) {
        guard let message = note(fromRegionIdentifier: region.identifier) else { return }
        guard let imageName = location(fromRegionIdentifier: region.identifier) else { return }
        
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = UNNotificationSound.default()
        let attachment = try! UNNotificationAttachment(identifier: "image", url: Bundle.main.url(forResource: imageName, withExtension: "png")!, options: nil)
        content.attachments = [attachment]
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        let notification = UNNotificationRequest(identifier: region.identifier, content: content, trigger: trigger)
        center.delegate = self
        center.add(notification){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription ?? "Error occured")
            }
        }
        
    }
    
    func loadData(){
        geoNotifications = []
        notificationData.loadAllGeoNotifications()
        let notificationAll = notificationData.geoNotifications
        
        for item in notificationAll {
            if item.status == "unread" {
                geoNotifications.append(item)
            }
            
        }
    }

}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            triggerNotification(forRegion: region)
            addNotification(forRegion: region)
            loadData()
            UIApplication.shared.applicationIconBadgeNumber = geoNotifications.count
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            triggerNotification(forRegion: region)
            addNotification(forRegion: region)
            loadData()
            UIApplication.shared.applicationIconBadgeNumber = geoNotifications.count
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
        loadData()
        UIApplication.shared.applicationIconBadgeNumber = geoNotifications.count
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        loadData()
        UIApplication.shared.applicationIconBadgeNumber = geoNotifications.count
        if UIApplication.shared.applicationState == UIApplicationState.active {
            let selectedView = UIApplication.topViewController()?.tabBarController
            let currentBadge:Int = Int((selectedView?.tabBar.items![2].badgeValue)!)!
            let updatedBadge = currentBadge + 1
            let badgeView = UIApplication.topViewController()?.tabBarController?.tabBar.items![2]
            badgeView?.badgeValue = "\(updatedBadge)"
            if selectedView?.selectedIndex == 2{
                selectedView?.view.makeToast("Click unread to view latest notifications", duration: 2.0, position: .bottom)
            }
        }
        completionHandler( [.alert,.sound,.badge])
        
    }
}
