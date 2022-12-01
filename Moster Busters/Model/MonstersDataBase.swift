//
//  MonstersDataBase.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 01.12.2022.
//

import UIKit

enum MonstersDataBase {

    static var allMonsters: [Monster] = [
        Monster(name: "Robbie", assetName: "robbie"),
        Monster(name: "Broodmother", assetName: "broodmother"),
        Monster(name: "Imp", assetName: "imp"),
        Monster(name: "Choozie", assetName: "choozie"),
        Monster(name: "Knuckle", assetName: "knuckle"),
        Monster(name: "Tautau", assetName: "tautau"),
        Monster(name: "Nevery", assetName: "nevery"),
        Monster(name: "Druke", assetName: "druke"),
        Monster(name: "Vampire", assetName: "vampire"),
        Monster(name: "Hoo-hoo", assetName: "hoohoo"),
        Monster(name: "Pikachu", assetName: "pikachu"),
        Monster(name: "Drummer", assetName: "drummer")
    ]

    static func returnSixRandomMonstersFromBase() -> [Monster] {
        var monstersToShuffle: [Monster] = []
        for monster in allMonsters {
            let newMonster = Monster(name: monster.name, assetName: monster.assetName) //создаем нового монстра для уникального UUID
            monstersToShuffle.append(newMonster)
        }
        let mostersShuffled: [Monster] = monstersToShuffle.shuffled()
        var monstersToReturn: [Monster] = []
        for index in 0...5 {
            monstersToReturn.append(mostersShuffled[index])
        }
        return monstersToReturn
    }

    static func returnTenRandomMonstersFromBase() -> [Monster] {
        func returnRandomIndex() -> Int {
            let randomIndex = Int.random(in: 0..<allMonsters.count)
            return randomIndex
        }
        var monstersToReturn: [Monster] = []
        for _ in 0..<20 {
            let randomIndex = returnRandomIndex()
            let monsterName = allMonsters[randomIndex].name
            let monsterAssetName = allMonsters[randomIndex].assetName //создаем нового монстра для уникального UUID
            let monster = Monster(name: monsterName, assetName: monsterAssetName)
            monstersToReturn.append(monster)
        }
        return monstersToReturn
    }

}

