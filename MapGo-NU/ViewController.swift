//
//  ViewController.swift
//  MapGo-NU
//
//  Created by Siwawes Wongcharoen on 3/9/2560 BE.
//  Copyright © 2560 siwaweswongcharoen. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var gMapView: GMSMapView!
    
    var mLocation: CLLocation?
    var mLocationManager: CLLocationManager?
    
    let acceptableAccuracy = 100.0
    var didMoveCameraToMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initLocationManager()
        
        initGoogleMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLocationManager() {
        mLocationManager = CLLocationManager()
        mLocationManager?.delegate = self
        mLocationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        mLocationManager?.requestWhenInUseAuthorization()
        // locationManager.startUpdatingLocation()
    }
    
    func initGoogleMap() {
        gMapView.isMyLocationEnabled = true
        
        gMapView.settings.myLocationButton = true
        gMapView.settings.compassButton = true
        
        moveCameraToThailand()
    }
    
    func moveCameraToThailand() {
        let thailand = GMSCameraPosition.camera(withLatitude: 14.1346, longitude: 101.0472, zoom: 5)
        gMapView.camera = thailand
    }
    
    func moveCameraToMyLocation() {
        let lat = mLocation?.coordinate.latitude
        let lng = mLocation?.coordinate.longitude
        let myLoc = GMSCameraPosition.camera(withLatitude: lat!, longitude: lng!, zoom: 15)
        //        gMapView.camera = thailand
        gMapView.animate(to: myLoc)
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            mLocation = location
            print(location)
            
            if (mLocation?.horizontalAccuracy)!<acceptableAccuracy && !didMoveCameraToMyLocation {
                didMoveCameraToMyLocation = !didMoveCameraToMyLocation
                moveCameraToMyLocation()
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else if status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


