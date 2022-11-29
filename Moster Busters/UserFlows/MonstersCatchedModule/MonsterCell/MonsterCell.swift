//
//  MonsterCell.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 29.11.2022.
//

import UIKit

class MonsterCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var monsterNameLabel: UILabel!
    @IBOutlet private weak var monsterLvl: UILabel!
    @IBOutlet private weak var outerView: UIView!
    @IBOutlet private weak var innerView: UIView!
    @IBOutlet private weak var monsterImageView: UIImageView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    // MARK: - Methods

    func configure(with model: Monster) {
        monsterNameLabel.text = model.name.uppercased()
        monsterNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        monsterLvl.text = "\(model.lvl) LVL"
        monsterLvl.font = .systemFont(ofSize: 17, weight: .bold)
        monsterImageView.image = UIImage(named: model.assetName)
    }

    // MARK: - Private methods

    private func configureAppearance() {
        outerView.backgroundColor = ColorsStorage.purple
        outerView.layer.cornerRadius = 10

        innerView.backgroundColor = ColorsStorage.pink
        innerView.layer.cornerRadius = 10
    }
    
}
