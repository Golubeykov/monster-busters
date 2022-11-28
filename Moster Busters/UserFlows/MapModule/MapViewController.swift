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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverToDetectIfAppMovedToForeground()
    }

}

// MARK: - Private extension

private extension MapViewController {

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
