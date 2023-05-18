//
//  ViewController.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 17.04.2023.
//

import UIKit
import SnapKit

enum Sorting: String {
    case asc = "Asc ↑"
    case desc = "Desc ↓"
}

final class CoinListViewController: DefaultViewController {

    private var sorting = Sorting.asc {
        willSet {
            if newValue == Sorting.asc {
                sortButton.setTitle(Sorting.asc.rawValue, for: .normal)
            } else {
                sortButton.setTitle(Sorting.desc.rawValue, for: .normal)
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var presenter: PresenterProtocol?
    
    private let cellIdentifier = CoinListTableViewCell.identifier
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle(Sorting.asc.rawValue, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(sortDidClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()
    
    private let coinNames = ["btc", "eth", "tron", "polkadot", "dogecoin", "tether", "stellar", "cardano", "xrp"]
    
    override func viewDidLoad() {
        title = "Coins"
        view.backgroundColor = .white
        setupActivityIndicator()
        presenter = Presenter()
        presenter?.setView(self)
        presenter?.loadCoins(coinNames: coinNames)
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }
    
    private func setupTable() {

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CoinListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func sortDidClicked(_ sender: AnyObject) {
        presenter?.sort(sorting: sorting)
        sorting = sorting == .asc ? .desc : .asc
        tableView.reloadData()
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
        headerView.addSubview(sortButton)
        
        sortButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        sortButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        sortButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CoinListTableViewCell
        cell?.name.text = presenter?.coinNameForRow(at: indexPath)
        cell?.symbol.text = presenter?.coinSymbolForRow(at: indexPath)
        cell?.price_usd.text = presenter?.coinPriceUsdForRow(at: indexPath)
        cell?.percent_change_usd_last_24_hours.text = presenter?.coinPricePercentChangeUsdLast24HoursForRow(at: indexPath)
        return cell ?? UITableViewCell()
    }
}

 // MARK: - UITableViewDelegate

extension CoinListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coinName = presenter?.coinNameForRow(at: indexPath) else { return }
        navigationController?.pushViewController(CoinDetailsViewController(coinName: coinName), animated: true)
    }
}

// MARK: - ColorListViewProtocol

extension CoinListViewController: ViewProtocol {
    func success() {
        activityIndicator.stopAnimating()
        setupTable()
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
        self.showAlert {
            self.presenter?.loadCoins(coinNames: self.coinNames)
        } cancelAction: {
            self.activityIndicator.stopAnimating()
            self.view.addSubview(self.noDataLabel)
            self.noDataLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }

    }
}
