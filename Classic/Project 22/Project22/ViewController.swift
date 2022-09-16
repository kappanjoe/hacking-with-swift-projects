//
//  ViewController.swift
//  Project22
//
//  Created by Joseph Van Alstyne on 9/16/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var uuidReading: UILabel!
    @IBOutlet var proxRing: UIImageView!
    
    var locationManager: CLLocationManager?
    var beaconDetectedAlertShown: Bool?
    let uuidArr = ["EA040D34-E4D0-4C5E-A0D7-E35CEAF63A66", "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", "74278BDA-B644-4520-8F0C-720EAF059935"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager =  CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        beaconDetectedAlertShown = false
        
        view.backgroundColor = .lightGray
        proxRing.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        proxRing.layer.zPosition = -1
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            stopScanning(exceptUUID: beacon.uuid.uuidString)
            update(distance: beacon.proximity)
            uuidReading.text = beacon.uuid.uuidString
            if !beaconDetectedAlertShown! {
                let ac = UIAlertController(title: "Beacon Detected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                beaconDetectedAlertShown = true
            }
        } else {
            update(distance: .unknown)
        }
    }
    
    func startScanning() {
        for uuid in uuidArr {
            // Create constraint and add to dictionary (per current iBeacon documentation)
            let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: uuid)!)
            let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: uuid)
            
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func stopScanning(exceptUUID: String?) {
        for uuid in uuidArr.filter({ element in
            element != exceptUUID
        }) {
            let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: uuid)!)
            let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: uuid)
            
            locationManager?.stopMonitoring(for: beaconRegion)
            locationManager?.stopRangingBeacons(in: beaconRegion)
        }
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.8, alpha: 1)
                self.distanceReading.text = "FAR"
                self.proxRing.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 1.0, alpha: 1)
                self.distanceReading.text = "NEAR"
                self.proxRing.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 1.0, alpha: 1)
                self.distanceReading.text = "RIGHT HERE"
                self.proxRing.transform = CGAffineTransform(scaleX: 1, y: 1)
            default:
                self.view.backgroundColor = UIColor.lightGray
                self.distanceReading.text = "UNKNOWN"
                self.proxRing.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
}

