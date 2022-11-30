//
//  MonsterModel.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 29.11.2022.
//

import UIKit

struct Monster {

    let id: UUID = UUID()
    let name: String
    let assetName: String
    var image: UIImage { UIImage(named: assetName) ?? UIImage() }
    let lvl: Int = Int.random(in: 5...20)

}
