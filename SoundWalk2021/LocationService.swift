//
//  LocationService.swift
//  SoundWalk2021
//
//  Created by Joseph Simeone on 7/7/20.
//  Copyright © 2020 Joseph Simeone. All rights reserved.
//
import UIKit
import CoreLocation

public class LocationService: NSObject, CLLocationManagerDelegate {

    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var locationDataArray: [CLLocation]

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        locationManager.requestWhenInUseAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationDataArray = [CLLocation]()
        super.init()
        locationManager.delegate = self

    }


    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            showTurnOnLocationServicesAlert()
        }
    }

    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }

   public func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")

            var locationAdded: Bool
            locationAdded = filterAndAddLocation(newLocation)

            if locationAdded{
                notifyDidUpdateLocation(newLocation: newLocation)
            }
        }
    }

    func filterAndAddLocation(_ location: CLLocation) -> Bool{
        let age = location.timestamp.timeIntervalSinceNow

        if age > 10{
            return false
        }

        if location.horizontalAccuracy < 0{
            return false
        }

        if location.horizontalAccuracy > 40{
            return false
        }
        locationDataArray.append(location)
        return true
    }

    func showTurnOnLocationServicesAlert() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showTurnOnLocationServicesAlert"), object: nil)
    }

    func notifyDidUpdateLocation(newLocation:CLLocation) {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])
    }
}
