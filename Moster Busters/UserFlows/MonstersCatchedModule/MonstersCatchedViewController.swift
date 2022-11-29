//
//  MonstersCatchedViewController.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 29.11.2022.
//

import UIKit

final class MonstersCatchedViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var monstersCathed: [Monster] {
        //MonstersCatched.shared.getCatchedMonstersList()
        var monster = Monster(name: "Robbie", assetName: "robbie")
        return [monster, monster]
    }
    let monsterCellIdentifier = "\(MonsterCell.self)"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

}

// MARK: - Private extension

private extension MonstersCatchedViewController {

    func configureTableView() {
        tableView.register(UINib(nibName: monsterCellIdentifier, bundle: .main), forCellReuseIdentifier: monsterCellIdentifier)
        tableView.dataSource = self
    }

}

// MARK: - TableView DataSource

extension MonstersCatchedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        monstersCathed.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: monsterCellIdentifier, for: indexPath) as? MonsterCell else {
            return UITableViewCell()
        }
        cell.configure(with: monstersCathed[indexPath.row])
        return cell
    }

}


