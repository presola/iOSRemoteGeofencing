//
//  Extras.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-01.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        setRegion(region, animated: true)
    }
    
}

extension UIViewController{
    func updateBadgeNumber(){
        let notificationData = NotificationData()
        notificationData.loadAllGeoNotifications()
        let geoNotifications = notificationData.geoNotifications
        self.tabBarController?.tabBar.items![2].badgeValue = "\(geoNotifications.count)"
    }
}

extension UIApplication{
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigation = base as? UINavigationController{
            let navigationItem = navigation.visibleViewController
            return topViewController(base: navigationItem)
        }
        if let tabControl = base as? UITabBarController {
            if let selectedTab = tabControl.selectedViewController {
                return topViewController(base: selectedTab)
            }
        }
        
        if let presentedView = base?.presentedViewController{
            return topViewController(base: presentedView)
        }
        return base
    }
}
