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

enum MonstersDataBase {

    static var allMonsters: [Monster] = [
        Monster(name: "Robbie", assetName: "robbie"),
        Monster(name: "Broodmother", assetName: "broodmother"),
        Monster(name: "Imp", assetName: "imp"),
        Monster(name: "Choozie", assetName: "choozie"),
        Monster(name: "Knuckle", assetName: "nuckle"),
        Monster(name: "Tautau", assetName: "tautau"),
        Monster(name: "Nevery", assetName: "nevery")
    ]

    static func returnFiveRandomMonstersFromBase() -> [Monster] {
        let mostersShuffled: [Monster] = self.allMonsters.shuffled()
        var monstersToReturn: [Monster] = []
        for index in 0..<5 {
            monstersToReturn.append(mostersShuffled[index])
        }
        return monstersToReturn
    }

}
