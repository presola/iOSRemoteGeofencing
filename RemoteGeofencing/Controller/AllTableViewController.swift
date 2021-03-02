//
//  AllTableViewController.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-07.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import UIKit
import UserNotifications

class AllTableViewController: UITableViewController {
    
    let notificationData = NotificationData()
    var geoNotifications: [GeoNotification] = []
    var unreadGeoNotifications: [GeoNotification] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        loadUnreadData()
        tableView.reloadData()
        showUpdatedNotification()
    }
    
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let top = rect.size.height + rect.origin.y
            let bottom = self.tabBarController!.tabBar.frame.height
            let inset = UIEdgeInsetsMake( top, 0, bottom, 0)
            if self.tableView.contentInset != inset{
                self.tableView.contentInset = inset
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return geoNotifications.count
    }
    
    func loadData(){
        notificationData.loadAllGeoNotifications()
        geoNotifications = notificationData.geoNotifications
    }
    
    func loadUnreadData(){
        unreadGeoNotifications = []
        for item in geoNotifications {
            if item.status == "unread" {
                unreadGeoNotifications.append(item)
            }
            
        }
    }
    
    func showUpdatedNotification(){
        self.tabBarController?.tabBar.selectedItem?.badgeValue = "\(unreadGeoNotifications.count)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allDataCells", for: indexPath) as! NotificationCells
        
        // Configure the cell...
        var imageView : UIImageView
        imageView  = UIImageView(frame: CGRect(x: 20, y: 20, width: 34, height: 11))
        imageView.contentMode = .scaleAspectFit
        let object = geoNotifications[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = object.note
        cell.subtitleLabel.text = object.eventType.rawValue
        imageView.image = UIImage(named: object.status)
        cell.accessoryView = imageView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            let alertController = UIAlertController(title: "More actions", message: "Choose one or more extra options", preferredStyle: .actionSheet)
            let indexInArray = index.row
            let dataGeo = self.geoNotifications[indexInArray]
            let dataGeoStatus = dataGeo.status
            var changeInStatus: String? {
                if dataGeoStatus == "read" {
                    return "Mark as Unread"
                }
                return "Mark as Read"
            }
            let  status = UIAlertAction(title: changeInStatus, style: .default) { (action) -> Void in
                if dataGeoStatus == "read" {
                    dataGeo.status = "unread"
                    self.notificationData.geoNotifications[indexInArray] = dataGeo
                    self.notificationData.saveAllGeoNotifications()
                    self.loadData()
                    self.tableView.reloadData()
                    self.loadUnreadData()
                    self.showUpdatedNotification()
                }
                else{
                    dataGeo.status = "read"
                    self.notificationData.geoNotifications[indexInArray] = dataGeo
                    self.notificationData.saveAllGeoNotifications()
                    self.loadData()
                    self.tableView.reloadData()
                    self.loadUnreadData()
                    self.showUpdatedNotification()
                }
            }
            let delete = UIAlertAction(title: "Delete All", style: .default, handler: { (action) -> Void in
                
                let alertController = UIAlertController(title: "Confirm Delete", message: "Confirm Delete all", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    self.notificationData.geoNotifications.removeAll()
                    self.notificationData.saveAllGeoNotifications()
                    self.loadData()
                    self.tableView.reloadData()
                    self.loadUnreadData()
                    self.showUpdatedNotification()
                }
                alertController.addAction(yesAction)
                
                let noAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction!) in
                    print("you have pressed No button");
                }
                alertController.addAction(noAction)
                
                self.present(alertController, animated: true, completion:nil)
            })
            let  cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            
            alertController.addAction(status)
            alertController.addAction(delete)
            alertController.addAction(cancel)
            
            self.present(alertController, animated: true, completion: nil)
        }
        more.backgroundColor = UIColor.darkGray
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.notificationData.geoNotifications.remove(at: index.row)
            self.notificationData.saveAllGeoNotifications()
            self.loadData()
            self.tableView.reloadData()
            self.loadUnreadData()
            self.showUpdatedNotification()
            
        }
        delete.backgroundColor = UIColor.red
        
        return [delete, more]
    }
    
    
}


