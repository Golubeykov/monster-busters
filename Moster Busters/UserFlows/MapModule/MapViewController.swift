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
    @IBOutlet private weak var myTeamButtonLabel: UIButton!
    // MARK: - Properties

    let notificationCenter = NotificationCenter.default
    let locationManager = CLLocationManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStartButton()
        addObserverToDetectIfAppMovedToForeground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMapView()
        createRandomAnnotations()
    }

    // MARK: - IBActions


    @IBAction func zoomInButtonAction(_ sender: Any) {
        let region = MKCoordinateRegion(center: self.mapView.region.center,
                                        span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta * 0.7,
                                                               longitudeDelta: mapView.region.span.longitudeDelta * 0.7))
        mapView.setRegion(region, animated: true)
    }

    @IBAction func zoomOutButtonAction(_ sender: Any) {
        let zoom = getZoom()
        if zoom > 3.5{
            let region = MKCoordinateRegion(center: self.mapView.region.center,
                                            span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta / 0.7,
                                                                   longitudeDelta: mapView.region.span.longitudeDelta / 0.7))
            mapView.setRegion(region, animated: true)
        }
        func getZoom() -> Double {
            var angleCamera = self.mapView.camera.heading
            if angleCamera > 270 {
                angleCamera = 360 - angleCamera
            } else if angleCamera > 90 {
                angleCamera = fabs(angleCamera - 180)
            }
            let angleRad = Double.pi * angleCamera / 180
            let width = Double(self.view.frame.size.width)
            let height = Double(self.view.frame.size.height)
            let heightOffset : Double = 20
            let spanStraight = width * self.mapView.region.span.longitudeDelta / (width * cos(angleRad) + (height - heightOffset) * sin(angleRad))
            return log2(360 * ((width / 256) / spanStraight)) + 1;
        }
    }

    @IBAction func centerMapAction(_ sender: Any) {
        centerOnUserLocation()
    }
    
    @IBAction func myTeamButtonAction(_ sender: Any) {
       present(CatchMonsterViewController(), animated: true)
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

    func configureStartButton() {
        myTeamButtonLabel.backgroundColor = ColorsStorage.purple
        myTeamButtonLabel.setTitle("Моя команда", for: .normal)
        myTeamButtonLabel.titleLabel?.font = .systemFont(ofSize: 23, weight: .semibold)
        myTeamButtonLabel.tintColor = ColorsStorage.white
        myTeamButtonLabel.layer.cornerRadius = 10
    }

}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerOnUserLocation()
    }

}
