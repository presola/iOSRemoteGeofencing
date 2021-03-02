//
//  AddGeoViewController.swift
//  RemoteGeofencing
//
//  Created by Abisola A & Presly E on 2016-12-02.
//  Copyright © 2016 Abisola A & Presly E. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Toast_Swift

class AddGeoViewController: UITableViewController {
    
    var delegate: AddGeoViewControllerDelegate?
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var entryType: UISegmentedControl!
    @IBOutlet var pickerLocation: UIPickerView!
    @IBOutlet var noteTextField: UITextField!
    @IBOutlet var radiusTextField: UITextField!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    let pickerData = ["Home", "Work", "Others"]
    
    var resultSearchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickerLocation.delegate = self
        pickerLocation.dataSource = self
        saveButton.isEnabled =  false
        self.view.makeToast("Enter a note and ensure radius is not empty to enable the save button", duration: 4.0, position: .top)
        loadSearchBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func zoomToLocation(_ sender: UIBarButtonItem) {
        mapView.zoomToUserLocation()
    }
    
    @IBAction func cancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNoteBegin(_ sender: UITextField) {
        self.view.makeToast("Note length must be greater than 3", duration: 4.0, position: .top)
    }
    
    @IBAction func addNoteChanged(_ sender: UITextField) {
        saveButton.isEnabled = !radiusTextField.text!.isEmpty && (noteTextField.text?.count)! > 3
    }
    
    
    @IBAction func saveGeoData(_ sender: UIBarButtonItem) {
        let coordinate = mapView.centerCoordinate
        let radius = Double(radiusTextField.text!) ?? 0
        let identifier = NSUUID().uuidString
        let note = noteTextField.text
        let eventType: EventType = (entryType.selectedSegmentIndex == 0) ? .onEntry : .onExit
        let selectedRow = pickerLocation.selectedRow(inComponent: 0)
        let location = pickerData[selectedRow]
        delegate?.addGeoData(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: eventType, location: location, status: "unread")
    }
    
}

protocol AddGeoViewControllerDelegate {
    func addGeoData(controller: AddGeoViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType, location: String, status: String)
}

extension AddGeoViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func  pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = pickerData[row]
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 12)
        pickerLabel.backgroundColor = UIColor.gray
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
}


extension AddGeoViewController{
    func loadSearchBar(){
        let searchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchController") as! LocationSearchController
        resultSearchController = UISearchController(searchResultsController: searchTable)
        resultSearchController?.searchResultsUpdater = searchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for location"
        //searchBar.showsCancelButton = true
        
        searchBar.tintColor = UIColor.gray
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        searchTable.mapView = mapView
        searchTable.handleMapSearchDelegate = self
        
    }
}

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

extension AddGeoViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark:MKPlacemark){
        let annotation = MKPointAnnotation()
        mapView.removeAnnotation(annotation)
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion.init(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
}
