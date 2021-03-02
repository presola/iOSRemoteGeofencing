//
//  GeoTableViewController.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-02.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import UIKit
import CoreLocation

class GeoTableViewController: UITableViewController{
    
    var geoDataSet: [GeoData] = []
    let locationManager = CLLocationManager()
    let geoView = GeoViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllGeoData()
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAllGeoData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addData" {
            self.tableView.isEditing = false
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.viewControllers.first as! AddGeoViewController
            viewController.delegate = self
        }
    }
    
    
    func loadAllGeoData(){
        geoDataSet = []
        guard let savedItems = UserDefaults.standard.array(forKey: UserDefaultKeys.savedData) else { return }
        for savedItem in savedItems {
            guard let geoData = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? GeoData else { continue }
            geoDataSet.append(geoData)
        }
    }
    // MARK: - Table view data source
    
    /*        // #warning Incomplete implementation, return the number of sections
     return 0
     }
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return geoDataSet.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeoDataCell", for: indexPath) as! GeoDataCell
        
        // Configure the cell...
        let object = geoDataSet[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = object.note
        let subtitle = "\(object.eventType) (radius: \(String(object.radius)))"
        cell.subtitleLabel.text = subtitle
        return cell
    }
    
    func saveAllGeoData() {
        var items: [Data] = []
        for geoData in geoDataSet {
            let item = NSKeyedArchiver.archivedData(withRootObject: geoData)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: UserDefaultKeys.savedData)
    }
    
    @IBAction func deleteCells(_ sender: UIBarButtonItem) {
        
        
        if self.tableView.isEditing == false{
            let alertController = UIAlertController(title: "Delete Points", message: "Choose an option to delete muliple point or all geo points, note that data will be deleted on the map also", preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete Selected", style: .default, handler: { (action) -> Void in
                self.tableView.isEditing = true
            })
            let deleteall = UIAlertAction(title: "Delete All", style: .default, handler: { (action) -> Void in
                
                let alertController = UIAlertController(title: "Confirm Delete", message: "Confirm Delete all", preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                    self.geoDataSet.removeAll()
                    self.saveAllGeoData()
                    self.loadAllGeoData()
                    self.tableView.reloadData()
                    self.tabBarController?.tabBar.items![0].title = "Geo (\(self.geoDataSet.count))"
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
            
            alertController.addAction(delete)
            alertController.addAction(deleteall)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
        }
        else{
            let rows = self.tableView.indexPathsForSelectedRows
            if rows == nil{
                self.tableView.isEditing = false
            }
            else{
                let alertController = UIAlertController(title: "Confirm Delete", message: " Delete Selected Points", preferredStyle: .actionSheet)
                let delete = UIAlertAction(title: "Delete Selected", style: .default, handler: { (action) -> Void in
                    let sortedRows = rows?.sorted().reversed()
                    for row in sortedRows! {
                        let selected = row as NSIndexPath
                        self.geoDataSet.remove(at: selected.row)
                        self.saveAllGeoData()
                        self.loadAllGeoData()
                        self.tableView.reloadData()
                        self.tabBarController?.tabBar.items![0].title = "Geo (\(self.geoDataSet.count))"
                    }
                    
                })
                let  cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    self.tableView.isEditing = false
                }
                
                alertController.addAction(delete)
                alertController.addAction(cancel)
                
                present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
}
extension GeoTableViewController: AddGeoViewControllerDelegate{
    func addGeoData(controller: AddGeoViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType, location: String, status: String) {
        controller.dismiss(animated: true, completion: nil)
        
        //get current location
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geoData = GeoData(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType, location: location, status: status)
        self.geoDataSet.append(geoData)
        self.geoView.startMonitoring(geoData: geoData)
        self.saveAllGeoData()
        self.tabBarController?.tabBar.items![0].title = "Geo (\(geoDataSet.count))"
        
    }
}


