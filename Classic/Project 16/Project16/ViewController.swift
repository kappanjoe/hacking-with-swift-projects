//
//  ViewController.swift
//  Project16
//
//  Created by Joseph Van Alstyne on 9/12/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    var webCapital: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Capitals"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(mapStyleChooser))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        let tokyo = Capital(title: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.6895000, longitude: 139.6917100), info: "Largest metropolis in the world.")
        
//        mapView.addAnnotation(london)
//        mapView.addAnnotation(oslo)
//        mapView.addAnnotation(paris)
//        mapView.addAnnotation(rome)
//        mapView.addAnnotation(washington)
//        mapView.addAnnotation(tokyo)
        
        mapView.addAnnotations([london, oslo, paris, rome, washington, tokyo])
        mapView.mapType = .mutedStandard
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Return nil if the annotation is not a Capital
        guard annotation is Capital else { return nil }
        // Define reuse identifier to ensure reuse of annotation views
        let identifier = "Capital"
        // Try dequeue of unused annotation view
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            // Create new annotation view if none available
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            // Create button with detail disclosure type
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // Or, reuse unused annotation view
            annotationView?.annotation = annotation
        }
        annotationView?.pinTintColor = UIColor.darkGray
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info
        webCapital = placeName
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cool story, bro.", style: .default, handler: openPage))
        present(ac, animated: true)
    }
    
    @objc func mapStyleChooser() {
        let ac = UIAlertController(title: "Choose Map Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: chooseMapStyle))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: chooseMapStyle))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: chooseMapStyle))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func chooseMapStyle(action: UIAlertAction) {
        switch action.title {
        case "Hybrid":
            mapView.mapType = .hybrid
        case "Satellite":
            mapView.mapType = .satellite
        case "Standard":
            mapView.mapType = .mutedStandard
        default:
            mapView.mapType = .mutedStandard
        }
    }
                     
    func openPage(action: UIAlertAction) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Browser") as? WebViewController {
            vc.capital = webCapital
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

