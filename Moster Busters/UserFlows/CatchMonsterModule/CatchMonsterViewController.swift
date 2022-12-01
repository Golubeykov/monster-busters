//
//  CatchMonsterViewController.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 26.11.2022.
//

import UIKit
import RealityKit
import Combine

final class CatchMonsterViewController: UIViewController {

    // MARK: - Catch result cases

    private enum CatchResults {
        case success
        case tryAgain
        case failure
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var catchResultView: UIView!
    @IBOutlet private weak var catchResultLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchingForMonsterLabel: UILabel!
    @IBOutlet private weak var arView: ARView!
    @IBOutlet private weak var catchButtonLabel: UIButton!

    // MARK: - Private properties

    private var anchorIsActive: Cancellable!
    private lazy var actionForCatchButton: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        let catchResult = self.tryToCatch()
        switch catchResult {
        case .success:
            self.showSuccessCatchResult()
        case .tryAgain:
            self.showTryAgainCatchResult()
        case .failure:
            self.showFailureCatchResult()
        }
    }

    // MARK: - Properties

    var monster: Monster
    var monsterWasCatchedOrRunAway: () -> Void = {}
    var stopAnimationAsMonsterWasCatched: () -> Void = {}
    var hideMonsterAsItRanAway: () -> Void = {}

    // MARK: - Init

    init(monster: Monster) {
        self.monster = monster
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configure3DModel(for: monster)
    }

    // MARK: - Actions

    @IBAction func catchButtonAction(_ sender: Any) {
        actionForCatchButton()
    }

    @IBAction func closeModalViewAction(_ sender: Any) {
        dismiss(animated: true)
    }

}

// MARK: - Private methods

private extension CatchMonsterViewController {

    func configureAppearance() {
        configureCatchButton()
        configureCatchResultView()
    }

    func showSuccessCatchResult() {
        catchResultLabel.font = .systemFont(ofSize: 17, weight: .bold)
        catchResultLabel.text = "Ура! \nВы поймали монстра \(monster.name) (\(monster.lvl) уровня) в свою команду!!"
        catchResultView.isHidden = false
        catchButtonLabel.setTitle("Перейти к картам", for: .normal)
        MonstersCatched.shared.addMonster(monster)
        stopAnimationAsMonsterWasCatched()
        monsterWasCatchedOrRunAway()
        actionForCatchButton = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    func showTryAgainCatchResult() {
        catchResultLabel.font = .systemFont(ofSize: 17, weight: .bold)
        catchResultLabel.text = "Увы не вышло:( \nПопробуйте поймать еще раз!"
        catchResultView.isHidden = false
    }

    func showFailureCatchResult() {
        catchResultLabel.font = .systemFont(ofSize: 17, weight: .bold)
        catchResultLabel.text = "Упс :( \nМонстр успел убежать от вас"
        catchResultView.isHidden = false
        catchButtonLabel.setTitle("Перейти к картам", for: .normal)
        hideMonsterAsItRanAway()
        monsterWasCatchedOrRunAway()
        actionForCatchButton = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    func configureCatchResultView() {
        catchResultView.backgroundColor = ColorsStorage.purple
        catchResultView.alpha = 0.7
        catchResultView.layer.cornerRadius = 10
        catchResultView.isHidden = true
    }

    func configureCatchButton() {
        catchButtonLabel.backgroundColor = ColorsStorage.purple
        catchButtonLabel.setTitle("Попробовать поймать", for: .normal)
        catchButtonLabel.titleLabel?.adjustsFontSizeToFitWidth = true
        catchButtonLabel.tintColor = ColorsStorage.white
        catchButtonLabel.layer.cornerRadius = 10
        catchButtonLabel.isHidden = true
    }

    func configure3DModel(for monster: Monster) {
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.3, 0.3])
        arView.scene.addAnchor(anchor)
        var modelIsLoaded: AnyCancellable? = nil
        modelIsLoaded = ModelEntity.loadModelAsync(named: monster.assetName)
            .collect()
            .sink(receiveCompletion: { error in
                print("Error:", error)
                modelIsLoaded?.cancel()
            }, receiveValue: { [weak self] entities in
                for entity in entities {
                    entity.setScale(SIMD3<Float>(0.05, 0.05, 0.05), relativeTo: anchor)
                    entity.generateCollisionShapes(recursive: true)
                    entity.position = [0, 0, -1]
                    anchor.addChild(entity)
                    if entity.availableAnimations.count > 0 {
                        let animation = entity.availableAnimations[0]
                        entity.playAnimation(animation.repeat(duration: .infinity))
                    }
                    let entityBoundingBox = entity.visualBounds(relativeTo: anchor)
                    let boundingRadius = entityBoundingBox.boundingRadius * 2
                    print(boundingRadius)
                    let textMaterial = SimpleMaterial(color: .black, isMetallic: false)
                    let textEntity = ModelEntity(mesh: .generateText("\(monster.name), \(monster.lvl) lvl", extrusionDepth: 0.1, font: .boldSystemFont(ofSize: 4), containerFrame: .zero, alignment: .left, lineBreakMode: .byWordWrapping), materials: [textMaterial])
                    textEntity.setScale(SIMD3<Float>(0.5, 0.5, 0.5), relativeTo: entity)
                    textEntity.position = [-boundingRadius/4, boundingRadius/1.2, -1]
                    anchor.addChild(textEntity)

                    self?.stopAnimationAsMonsterWasCatched = {
                        entity.stopAllAnimations()
                    }
                    self?.hideMonsterAsItRanAway = {
                        entity.removeFromParent()
                        textEntity.removeFromParent()
                    }
                }
                modelIsLoaded?.cancel()
            })

        anchorIsActive = arView.scene.subscribe(to: SceneEvents.AnchoredStateChanged.self) { [weak self] event in
            if event.anchor.isActive {
                self?.activityIndicator.isHidden = true
                self?.searchingForMonsterLabel.isHidden = true
                self?.catchButtonLabel.isHidden = false
           }
            self?.anchorIsActive.cancel()
        }
    }

    private func tryToCatch() -> CatchResults {
        let randomInt = Int.random(in: 0..<3)
        switch randomInt {
        case 0:
            return .success
        case 1:
            return .tryAgain
        default:
            return .failure
        }
    }

}
