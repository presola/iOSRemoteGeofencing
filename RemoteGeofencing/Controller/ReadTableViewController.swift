//
//  ReadTableViewController.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-07.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import UIKit

class ReadTableViewController: UITableViewController {
    
    let notificationData = NotificationData()
    var geoNotifications: [GeoNotification] = []
    var unreadGeoNotifications: [GeoNotification] = []
    var readGeoNotifications: [GeoNotification] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadReadUnreadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        loadReadUnreadData()
        tableView.reloadData()
        showUpdatedNotification()
    }
    
    override func viewDidLayoutSubviews() {
        
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            let bottom = self.tabBarController!.tabBar.frame.height
            let inset = UIEdgeInsets.init( top: y, left: 0, bottom: bottom, right: 0)
            if self.tableView.contentInset != inset{
                self.tableView.contentInset = inset
            }
        }
        
    }
    
    func loadData(){
        notificationData.loadAllGeoNotifications()
        geoNotifications = notificationData.geoNotifications
    }
    
    func loadReadUnreadData(){
        readGeoNotifications = []
        unreadGeoNotifications = []
        for item in geoNotifications {
            if item.status == "read" {
                readGeoNotifications.append(item)
            }
            else{
                unreadGeoNotifications.append(item)
            }
            
        }
    }
    
    
    func showUpdatedNotification(){
        self.tabBarController?.tabBar.selectedItem?.badgeValue = "\(unreadGeoNotifications.count)"
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return readGeoNotifications.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readDataCells", for: indexPath) as! NotificationCells
        
        // Configure the cell...
        var imageView : UIImageView
        imageView  = UIImageView(frame: CGRect(x: 20, y: 20, width: 34, height: 11))
        imageView.contentMode = .scaleAspectFit
        let object = readGeoNotifications[(indexPath as NSIndexPath).row]
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            let alertController = UIAlertController(title: "More actions", message: "Choose one or more extra options", preferredStyle: .actionSheet)
            let indexInArray = index.row
            let geoInfo = self.readGeoNotifications[indexInArray]
            let geoIndex = self.notificationData.geoNotifications.firstIndex(of: geoInfo)
            let dataGeo = self.notificationData.geoNotifications[geoIndex!]
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
                    self.notificationData.geoNotifications[geoIndex!] = dataGeo
                    self.notificationData.saveAllGeoNotifications()
                    self.loadData()
                    self.loadReadUnreadData()
                    self.tableView.reloadData()
                    self.showUpdatedNotification()
                }
                else{
                    dataGeo.status = "read"
                    self.notificationData.geoNotifications[geoIndex!] = dataGeo
                    self.notificationData.saveAllGeoNotifications()
                    self.loadData()
                    self.loadReadUnreadData()
                    self.tableView.reloadData()
                    self.showUpdatedNotification()
                }
            }
            let delete = UIAlertAction(title: "Delete All", style: .default, handler: { (action) -> Void in
                
                let alertController = UIAlertController(title: "Confirm Delete", message: "Confirm Delete all", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    for geoIndex in self.readGeoNotifications{
                        if let indexInArray = self.notificationData.geoNotifications.firstIndex(of: geoIndex) {
                            self.notificationData.removeNotification(indexInArray: indexInArray)
                        }
                    }
                    self.notificationData.saveAllGeoNotifications()
                    self.loadData()
                    self.loadReadUnreadData()
                    self.tableView.reloadData()
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
            let geoInfo = self.readGeoNotifications[index.row]
            if let indexInArray = self.notificationData.geoNotifications.firstIndex(of: geoInfo) {
                self.notificationData.removeNotification(indexInArray: indexInArray)
            }
            self.notificationData.saveAllGeoNotifications()
            self.loadData()
            self.loadReadUnreadData()
            self.tableView.reloadData()
            self.showUpdatedNotification()
            
        }
        delete.backgroundColor = UIColor.red
        
        return [delete, more]
    }
    
}
