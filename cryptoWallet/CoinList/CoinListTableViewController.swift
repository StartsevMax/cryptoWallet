//
//  ViewController.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 17.04.2023.
//

import UIKit
import SnapKit

final class CoinListViewController: UIViewController {
        
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var presenter: CoinListPresenterProtocol?
    
    private let cellIdentifier = CoinListTableViewCell.identifier
    
    private var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("Asc ↑", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CoinListPresenter()
        presenter?.setView(self)
        setupTable()
    }

    func setupTable() {
        self.view.addSubview(tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(CoinListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.frame = view.frame
    }
    
    @objc func sortDidClicked(_ sender: AnyObject) {
        if sender.titleLabel?.text == "Asc ↑" {
            sortButton.setTitle("Desc ↓", for: .normal)
            presenter?.sort { $0.metrics.market_data.percent_change_usd_last_24_hours > $1.metrics.market_data.percent_change_usd_last_24_hours }
        } else {
            sortButton.setTitle("Asc ↑", for: .normal)
            presenter?.sort { $0.metrics.market_data.percent_change_usd_last_24_hours < $1.metrics.market_data.percent_change_usd_last_24_hours }
        }
        tableView.reloadData()
    }
    
    @objc func logoutDidClicked() {
        self.view.window?.rootViewController = LoginViewController()
        self.view.window?.makeKeyAndVisible()
        UserDefaults.standard.set(false, forKey: "isLogged")
    }
}

// MARK: - UITableViewDataSource

extension CoinListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numbersOfRowInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let title = UILabel()
        title.text = "Crypto currencies"
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let logout = UIButton()
        logout.setTitle("Log out", for: .normal)
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.setTitleColor(.systemRed, for: .normal)
        logout.addTarget(self, action: #selector(logoutDidClicked), for: .touchUpInside)
        
        headerView.addSubview(title)
        headerView.addSubview(logout)
        headerView.addSubview(sortButton)
        
        logout.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        logout.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        
        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: logout.bottomAnchor, constant: 5).isActive = true
        
        sortButton.addTarget(self, action: #selector(sortDidClicked), for: .touchUpInside)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        sortButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        sortButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CoinListTableViewCell
        cell?.slug.text = presenter?.coinSlugForRow(at: indexPath)
        cell?.symbol.text = presenter?.coinSymbolForRow(at: indexPath)
        cell?.price_usd.text = presenter?.coinPriceUsdForRow(at: indexPath)
        cell?.percent_change_usd_last_24_hours.text = presenter?.coinPricePercentChangeUsdLast24HoursForRow(at: indexPath)
        return cell ?? UITableViewCell()
    }
}

 // MARK: - UITableViewDelegate

extension CoinListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - ColorListViewProtocol

extension CoinListViewController: CoinListViewProtocol {
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}
