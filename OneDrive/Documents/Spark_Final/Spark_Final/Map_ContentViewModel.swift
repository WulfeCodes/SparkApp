//
//  ContentViewModel.swift
//  Spark
//
//  Created by Avihhan Arya Kumarr on 11/4/23.
//

import MapKit
import CoreLocation

// consts for map
enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let setdefaultSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
}

final class ContentViewModel: NSObject, ObservableObject,
     CLLocationManagerDelegate {
    
    // setting latitude and longitude and setting span.
    @Published var region = MKCoordinateRegion(center:
                                                MapDetails.startingLocation,
                                               span:
                                                MapDetails.setdefaultSpan)
    
    // turning the GPS location
    var locationManager: CLLocationManager? // object for locaiton preferences.
    
    // this func calls locationManager
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest // select the GPS accuracy.
            locationManager = CLLocationManager() // run location manager
            locationManager!.delegate = self // calling location manager prompt multiple times
        } else {
            print("GPS is not working!")
        }
    }
    
    // check if we have permission to have GPS location.
    func checkLocationAuthorization() {
        
        guard let locationManager = locationManager else { return }
        
        // checking authorization status fails.
        switch locationManager.authorizationStatus {
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted likely due to parental controls.")
            case .denied:
                print("You have denied this app locaiton permission. Go into settings to change it.")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                            span: MapDetails.setdefaultSpan) // location settings here. Set location values here.
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
