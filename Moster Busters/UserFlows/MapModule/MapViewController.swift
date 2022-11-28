//
//  MapViewController.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 28.11.2022.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var mapView: MKMapView!

    // MARK: - Properties

    let notificationCenter = NotificationCenter.default
    let locationManager = CLLocationManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addObserverToDetectIfAppMovedToForeground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMapView()
        createRandomAnnotations()
    }

}

// MARK: - Private extension

private extension MapViewController {

    func setupMapView() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapView.showsUserLocation = true
            locationManager.delegate = self
            centerOnUserLocation()
    }

    func createRandomAnnotations() {
        if let location = locationManager.location {
            GenerateRandomAnnotations.generateAnnoLoc(for: mapView, currentLocation: location)
        }
    }

    func centerOnUserLocation() {
      if let location = locationManager.location?.coordinate {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion.init(center: location, span: span)
        mapView.setRegion(region, animated: true)
     }
    }

    func addObserverToDetectIfAppMovedToForeground() {
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func appMovedToForeground() {
        checkLocationServices()
    }

    func checkLocationServices() {
        DispatchQueue.global().async {
            if (CLLocationManager.authorizationStatus() != .authorizedAlways) || (CLLocationManager.authorizationStatus() != .authorizedWhenInUse) {
                self.sendUserToStartGameFlow()
            }
        }
    }

    func sendUserToStartGameFlow() {
        DispatchQueue.main.async {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                let StartGameViewController = StartGameViewController()
                delegate.window?.rootViewController = StartGameViewController
            }
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerOnUserLocation()
    }

}
