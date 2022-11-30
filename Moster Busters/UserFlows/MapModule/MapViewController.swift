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
    @IBOutlet private weak var timerCounterLabel: UILabel!
    @IBOutlet private weak var timerTextLabel: UILabel!

    // MARK: - Properties

    var monsters: [Monster] = MonstersDataBase.returnTenRandomMonstersFromBase()
    let notificationCenter = NotificationCenter.default
    let locationManager = CLLocationManager()
    var timer: Timer?
    var currentTime: Int = 300

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        addObserverToDetectIfAppMovedToForeground()
        setupMapView()
        createAnnotationsForMonsters(monsters)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer == nil ? setupTimer() : ()
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
        if zoom > 3.5 {
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
        let monstersCatchedViewController = MonstersCatchedViewController()
        navigationController?.pushViewController(monstersCatchedViewController, animated: true)
    }

}

// MARK: - Private extension

private extension MapViewController {

    func setupMapView() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        locationManager.delegate = self
        mapView.delegate = self
        centerOnUserLocation()
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
            guard (CLLocationManager.authorizationStatus() == .authorizedAlways) || (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) else {
                self.sendUserToStartGameFlow()
                return
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

    func configureAppearance() {
        configureStartButton()
        configureLabels()
    }

    func configureStartButton() {
        myTeamButtonLabel.backgroundColor = ColorsStorage.purple
        myTeamButtonLabel.setTitle("Моя команда", for: .normal)
        myTeamButtonLabel.titleLabel?.font = .systemFont(ofSize: 23, weight: .semibold)
        myTeamButtonLabel.tintColor = ColorsStorage.white
        myTeamButtonLabel.layer.cornerRadius = 10
    }

    func configureLabels() {
        timerCounterLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        timerCounterLabel.textColor = ColorsStorage.white
        timerTextLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        timerTextLabel.textColor = ColorsStorage.white
    }

}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerOnUserLocation()
    }

}

// MARK: - MapView Delegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil  //Обработка аннотации локации пользователя
        }

        //Обработка аннотаций без картинок
        if !annotation.isKind(of: ImageAnnotation.self) {
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
            }
            return pinAnnotationView
        }

        //Обработка аннотаций с картинкой
        var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
        if view == nil {
            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
        }

        if let annotation = annotation as? ImageAnnotation {
            view?.image = annotation.image
            view?.annotation = annotation
        }
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let userCurrentCoordinate = locationManager.location?.coordinate, let annotation = annotation as? ImageAnnotation else { return }

        let userCurrentLocation = CLLocation(latitude: userCurrentCoordinate.latitude, longitude: userCurrentCoordinate.longitude)

        let annotationCoordinate = annotation.coordinate
        let annotationLocation = CLLocation(latitude: annotationCoordinate.latitude, longitude: annotationCoordinate.longitude)
        let distanceBetween = userCurrentLocation.distance(from: annotationLocation)

        if (distanceBetween <= 70) {
            AlertView.appendRequiredActionAlertView(textBody: "Перейти к поимке монстра?", textAction: "Да", confirmCompletion: { [weak self] _ in
                guard let monster = annotation.monster else { return }
                let catchMonsterVC = CatchMonsterViewController(monster: monster)
                catchMonsterVC.monsterWasCatchedOrRunAway = { [weak self] in
                    guard let monsterToRemove = annotation.monster else { return }
                    self?.mapView.removeAnnotation(annotation)
                    self?.removeMonster(monsterToRemove)
                    self?.checkIfMonstersMapIsEmpty()
                }
                catchMonsterVC.modalPresentationStyle = .fullScreen
                self?.present(catchMonsterVC, animated: true, completion: nil)
                self?.mapView.deselectAnnotation(annotation, animated: true)
            }) { [weak self] _ in
                self?.mapView.deselectAnnotation(annotation, animated: true)
            }
        } else {
            AlertView.appendInformingAlertView(textBody: "Монстр слишком далеко (\(Int(distanceBetween)) м), подойдите на расстояние менее 70 м") { [weak self] _ in
                self?.mapView.deselectAnnotation(annotation, animated: true)
            }
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationView = view as? ImageAnnotationView else { return }
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            annotationView.transform = CGAffineTransform(scaleX: 2, y: 2)
        })
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotationView = view as? ImageAnnotationView else { return }
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            annotationView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }

}

// MARK: - Timer logic

private extension MapViewController {

    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }

    func returnTimeForLabelFromTimer(_ timerTime: Int) -> String {
        let minutes = timerTime / 60
        let seconds = timerTime % 60
        return "\(minutes)m\(seconds)s"
    }

    func updateLabelWithTimer() {
        timerCounterLabel.text = returnTimeForLabelFromTimer(currentTime)
    }

    @objc func updateTimer() {
        currentTime > 0 ? currentTime -= 1 : resetCurrentTimeAndUpdateMosterMap()
        updateLabelWithTimer()
    }

    func resetCurrentTimeAndUpdateMosterMap() {
        updateMonsterMap()
        currentTime = 300
    }

}

// MARK: - Update monster map logic

private extension MapViewController {

    func updateMonsterMap() {
        removeMonstersRandomly()
        let newMonsters = MonstersDataBase.returnSixRandomMonstersFromBase()
        createAnnotationsForMonsters(newMonsters)
        monsters += newMonsters
    }

    func generateRandomInt() -> Int {
        return Int.random(in: 1...5)
    }

    // с вероятностью 20% каждый монстр будет удален с карты
    func removeMonstersRandomly() {
        for _ in 0..<monsters.count {
            if generateRandomInt() == 1 {
                let indexToRemove = Int.random(in: 0..<monsters.count)
                removeAnnotationWithParticularMonster(monsters[indexToRemove])
                monsters.remove(at: indexToRemove)
            }
        }
    }

    func createAnnotationsForMonsters(_ monsters: [Monster]) {
        guard let location = locationManager.location else { return }
        for index in monsters.indices {
            let monster = monsters[index]
            let annotation = ImageAnnotation()
            annotation.coordinate = RandomCoordinatesGenerator.generate(min: 30, max: 200, currentLocation: location)
            annotation.image = UIImage(named: monster.assetName)
            annotation.title = monster.name
            annotation.subtitle = "\(monster.lvl) lvl"
            annotation.monster = monster
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
            }
        }
    }

    func removeMonster(_ monsterToRemove: Monster) {
        for index in monsters.indices {
            if monsters[index].id == monsterToRemove.id {
                monsters.remove(at: index)
                break
            }
        }
    }

    func removeAnnotationWithParticularMonster(_ monster: Monster) {
        for annotation in mapView.annotations {
            guard let imageAnnotation = annotation as? ImageAnnotation,
                    let annotationMonster = imageAnnotation.monster,
                    monster.id == annotationMonster.id else { continue }
            mapView.removeAnnotation(imageAnnotation)
        }
    }

    func checkIfMonstersMapIsEmpty() {
        monsters.isEmpty ? monsters = MonstersDataBase.returnTenRandomMonstersFromBase() : ()
    }

}
