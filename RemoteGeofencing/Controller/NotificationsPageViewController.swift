//
//  NotificationsViewController.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-02.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import UIKit

class NotificationsPageViewController: UIPageViewController{
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    let notificationData = NotificationData()
    var geoNotifications: [GeoNotification] = []
    var pages = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "AllTableViewController")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "UnreadTableViewController")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "ReadTableViewController")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setView(index: 0)
        loadData()
        
        self.navigationController?.tabBarItem.badgeValue = "\(geoNotifications.count)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        self.tabBarController?.tabBar.selectedItem?.badgeValue = "\(geoNotifications.count)"
    }
    
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        setView(index: index)
    }
    
    
    func setView(index: Int){
        setViewControllers([pages[index]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        segmentedControl.selectedSegmentIndex = index
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
