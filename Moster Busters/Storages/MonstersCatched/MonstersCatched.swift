//
//  MonstersCatched.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 29.11.2022.
//

import Foundation

final class MonstersCatched {

    static let shared = MonstersCatched()
    private var monstersCatched: [Monster] = []

    private init() {

    }

    func getCatchedMonstersList() -> [Monster] {
        return monstersCatched
    }

    func addMonster(_ monster: Monster) {
        if !(monstersCatched.contains(where: { $0.id == monster.id })) {
            monstersCatched.append(monster)
        }
    }

}
