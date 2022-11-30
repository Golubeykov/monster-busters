//
//  MonstersCatchedViewController.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 29.11.2022.
//

import UIKit

final class MonstersCatchedViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Constants

    private enum Constants {
        static let arrowImageForNavigationBar = UIImage(named: "backArrowForNavigation") ?? UIImage()
    }

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var zeroScreenLabel: UILabel!

    // MARK: - Properties

    var monstersCathed: [Monster] {
        MonstersCatched.shared.getCatchedMonstersList()
    }
    let monsterCellIdentifier = "\(MonsterCell.self)"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

}

// MARK: - Private extension

private extension MonstersCatchedViewController {

    func configureAppearance() {
        configureTableView()
        configureNavigationBar()
        configureZeroScreenLabel()
    }

    func configureZeroScreenLabel() {
        zeroScreenLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        zeroScreenLabel.textColor = ColorsStorage.white
        zeroScreenLabel.text = "Вы ещё не поймали монстров :("
        zeroScreenLabel.isHidden = monstersCathed.isEmpty ? false : true
    }

    func configureTableView() {
        tableView.register(UINib(nibName: monsterCellIdentifier, bundle: .main), forCellReuseIdentifier: monsterCellIdentifier)
        tableView.dataSource = self
        tableView.allowsSelection = false
    }

    func configureNavigationBar() {
        navigationItem.title = "Пойманные монстры"
        let backButton = UIBarButtonItem(image: Constants.arrowImageForNavigationBar,
                                         style: .plain,
                                         target: navigationController,
                                         action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = ColorsStorage.white
        navigationController?.navigationBar.backgroundColor = ColorsStorage.clear
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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


