//
//  GeoViewController.swift
//  RemoteGeofencing
//
//  Created by Abisola Adeniran on 2016-11-30.
//  Copyright © 2016 Abisola Adeniran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Toast_Swift

class GeoViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var geoDataSet: [GeoData] = []
    
    let notificationData = NotificationData()
    var geoNotifications: [GeoNotification] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        
        
        loadAllGeoData()
        loadData()
        self.tabBarController?.tabBar.items![2].badgeValue = "\(geoNotifications.count)"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadAllGeoData()
        self.updateGeoDataCount()
        loadData()
        self.tabBarController?.tabBar.items![2].badgeValue = "\(geoNotifications.count)"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addData" {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.viewControllers.first as! AddGeoViewController
            viewController.delegate = self
        }
    }
    
    
    @IBAction func zoomToLocation(_ sender: UIBarButtonItem) {
        mapView.zoomToUserLocation()
    }
    
    
}
extension GeoViewController{
    func region(withGeotification geoData: GeoData) -> CLCircularRegion {
        let region = CLCircularRegion(center: geoData.coordinate, radius: geoData.radius, identifier: geoData.identifier)
        region.notifyOnEntry = (geoData.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geoData: GeoData) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            self.view.makeToast("Geofencing is not supported on this device!, click image to active", duration: 2.0, position: CGPoint(x: 110.0, y: 110.0), title: "Unsupported", image: UIImage(named: "placeholder"), style:nil) { (didTap: Bool) -> Void in
                if didTap {
                    self.locationManager.requestAlwaysAuthorization()
                } else {
                    self.view.makeToast("Permission not granted")
                }
            }
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            //showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
            self.view.makeToast("Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geoData)
        // 4
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: GeoData) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func add(geoData: GeoData){
        self.geoDataSet.append(geoData)
        self.mapView.addAnnotation(geoData)
        self.addRadiusOverlay(forGeoData: geoData)
        self.updateGeoDataCount()
    }
    
    func loadAllGeoData(){
        geoDataSet = []
        guard let savedItems = UserDefaults.standard.array(forKey: UserDefaultKeys.savedData) else { return }
        for savedItem in savedItems {
            guard let geoData = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? GeoData else { continue }
            add(geoData: geoData)
        }
    }
    
    func saveAllGeoData() {
        var items: [Data] = []
        for geoData in geoDataSet {
            let item = NSKeyedArchiver.archivedData(withRootObject: geoData)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: UserDefaultKeys.savedData)
    }
    
    func updateGeoDataCount(){
        self.title = "Geo (\(geoDataSet.count))"
        self.navigationItem.rightBarButtonItem?.isEnabled = (geoDataSet.count < 20)
    }
    
    func addRadiusOverlay(forGeoData geoData: GeoData) {
        mapView?.add(MKCircle(center: geoData.coordinate, radius: geoData.radius))
    }
    
    func remove(geoData: GeoData){
        if let indexInArray = geoDataSet.index(of: geoData) {
            geoDataSet.remove(at: indexInArray)
        }
        mapView.removeAnnotation(geoData)
        removeRadiusOverlay(forGeoData: geoData)
        updateGeoDataCount()
    }
    
    func removeRadiusOverlay(forGeoData geoData: GeoData) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geoData.coordinate.latitude && coord.longitude == geoData.coordinate.longitude && circleOverlay.radius == geoData.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    func removeAll(){
        for geoData in geoDataSet {
            removeRadiusOverlay(forGeoData: geoData)
            stopMonitoring(geotification: geoData)
        }
        mapView.removeAnnotations(geoDataSet)
        geoDataSet.removeAll()
        saveAllGeoData()
    }
    
}

extension GeoViewController: AddGeoViewControllerDelegate{
    func addGeoData(controller: AddGeoViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType, location: String, status: String) {
        controller.dismiss(animated: true, completion: nil)
        
        //get current location
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geoData = GeoData(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType, location: location, status: status)
        add(geoData: geoData)
        startMonitoring(geoData: geoData)
        saveAllGeoData()
    }
}


// MARK: - MapView Delegate
extension GeoViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeotification"
        if annotation is GeoData {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let smallSquare = CGSize(width: 30, height: 30)
                let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
                let annotationData = annotation as! GeoData
                let location = annotationData.location.lowercased()
                button.setBackgroundImage(UIImage(named: location), for: .normal)
                annotationView?.leftCalloutAccessoryView = button
                
                let removeButton = UIButton(type: .custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "delete")!, for: .normal)
                annotationView?.rightCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView{
            //Delete geotification
            let geoData = view.annotation as! GeoData
            stopMonitoring(geotification: geoData)
            remove(geoData: geoData)
            saveAllGeoData()
            
        }
        else{
            //Open geotification in maps
            let placemark = MKPlacemark(coordinate: (view.annotation?.coordinate)!)
            let mapItem = MKMapItem(placemark: placemark)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
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


extension GeoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
}

