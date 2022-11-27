//
//  CatchMonsterViewController.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 26.11.2022.
//

import UIKit
import RealityKit
import Combine

class CatchMonsterViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchingForMonsterLabel: UILabel!
    @IBOutlet private weak var arView: ARView!
    @IBOutlet private weak var catchButtonLabel: UIButton!

    // MARK: - Properties

    var anchorIsActive: Cancellable!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configure3DModel()
    }

    // MARK: - Actions

    @IBAction func catchButtonAction(_ sender: Any) {

    }


}

// MARK: - Private methods

private extension CatchMonsterViewController {

    func configureAppearance() {
        configureCatchButton()
    }

    func configureCatchButton() {
        catchButtonLabel.backgroundColor = ColorsStorage.purple
        catchButtonLabel.setTitle("Попробовать поймать", for: .normal)
        catchButtonLabel.titleLabel?.adjustsFontSizeToFitWidth = true
        catchButtonLabel.tintColor = ColorsStorage.white
        catchButtonLabel.layer.cornerRadius = 10
        catchButtonLabel.isHidden = true
    }

    func configure3DModel() {
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.3, 0.3])
        arView.scene.addAnchor(anchor)
        var modelIsLoaded: AnyCancellable? = nil
        modelIsLoaded = ModelEntity.loadModelAsync(named: "robot")
            .collect()
            .sink(receiveCompletion: { error in
                print("Error:", error)
                modelIsLoaded?.cancel()
            }, receiveValue: { entities in
                for entity in entities {
                    entity.setScale(SIMD3<Float>(0.05, 0.05, 0.05), relativeTo: anchor)
                    entity.generateCollisionShapes(recursive: true)
                    entity.position = [0, 0, -1]
                    anchor.addChild(entity)
                }
                modelIsLoaded?.cancel()
            })

        anchorIsActive = arView.scene.subscribe(to: SceneEvents.AnchoredStateChanged.self) { [weak self] event in
            if event.anchor.isActive {
                self?.activityIndicator.isHidden = true
                self?.searchingForMonsterLabel.isHidden = true
                self?.catchButtonLabel.isHidden = false
           }
        }

    }

}
