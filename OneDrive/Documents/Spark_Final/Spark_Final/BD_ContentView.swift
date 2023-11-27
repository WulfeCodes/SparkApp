//
//  ContentView.swift
//  BeaconDetector
//
//  Created by Avihhan Arya Kumarr on 11/5/23.
//

import Combine
import CoreLocation
import SwiftUI

// @objectBinding can be  replaced by @Published
// @Published var lastDistance = CLProximity.unknown

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var didChange = PassthroughSubject<Void, Never>() // can be deleted
    var locationManager: CLLocationManager?
    @Published var lastDistance = CLProximity.unknown
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major:123, minor:456)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: constraint)
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraints: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func update(distance: CLProximity) {
        lastDistance = distance
//        didChange.send(())
        
    }
}

struct BigText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 72, design: .rounded))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct ContentView: View {
    
    @ObservedObject var detector = BeaconDetector()
    
    var body: some View {
        
        if detector.lastDistance == .near || detector.lastDistance == .immediate {
            return Text("You got a Spark.")
                .modifier(BigText())
                .background(Color.orange)
                .edgesIgnoringSafeArea(.all)
        }else if detector.lastDistance == .far {
            return Text("FAR")
                .modifier(BigText())
                .background(Color.blue)
                .edgesIgnoringSafeArea(.all)
        }else {
            return Text("UNKNOWN")
                .modifier(BigText())
                .background(Color.gray)
                .edgesIgnoringSafeArea(.all)
        }
            
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
