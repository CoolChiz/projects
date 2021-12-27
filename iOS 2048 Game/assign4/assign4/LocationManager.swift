//
//  LocationManager.swift
//  assign4
//
//  Created by Duy on 10/26/21.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locatonManager = CLLocationManager()
    @Published var location = CLLocationCoordinate2D(latitude: 37, longitude: -67)
    @Published var path: [CLLocationCoordinate2D] = []
    @Published var currPath: [CLLocationCoordinate2D] = []
    @Published var startState = false
    override init() {
        super.init()
        self.locatonManager.delegate = self
        self.locatonManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locatonManager.requestWhenInUseAuthorization()
        self.locatonManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            location = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            if(startState == true) {
                //path.append(CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude))
                currPath.append(CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude))
            }
        }
    }
    
    func convertCoordinate2D(locations: [CLLocation]) {
        for location in locations {
            path.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
    }
    
}
