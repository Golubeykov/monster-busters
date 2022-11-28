//
//  StartGameViewController.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 28.11.2022.
//

import UIKit
import MapKit

class StartGameViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var startGameButtonLabel: UIButton!

    // MARK: - Properties

    let locationManager = CLLocationManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStartButton()
    }

    
    @IBAction func startGameButtonAction(_ sender: Any) {
        checkLocationServices()
    }
}

private extension StartGameViewController {

    func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async { [weak self] in
                    self?.checkLocationAuthorization()
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlertForTurningOnLocation()
                }
            }
        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            initGame()
        case .denied:
            showAlertForTurningOnLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlertForTurningOnLocation()
        case .authorizedAlways:
            initGame()
        }
    }

    func configureStartButton() {
        startGameButtonLabel.backgroundColor = ColorsStorage.purple
        startGameButtonLabel.setTitle("Начать игру", for: .normal)
        startGameButtonLabel.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        startGameButtonLabel.tintColor = ColorsStorage.white
        startGameButtonLabel.layer.cornerRadius = 30
    }

    func showAlertForTurningOnLocation() {
        AlertView.appendRequiredActionAlertView(textBody: "Ваше местоположение нужно для отображения ближайших монстров на карте", textAction: "Перейти в настройки", completion: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        })
    }

    func initGame() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let MapViewController = MapViewController()
            delegate.window?.rootViewController = MapViewController
        }
    }

}
