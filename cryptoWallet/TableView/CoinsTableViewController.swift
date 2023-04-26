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
    
    private let presenter: CoinListPresenterProtocol = CoinListPresenter()
    
    private let cellIdentifier = CoinListTableViewCell.identifier
    
    private var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("Asc ↑", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    func setupTable() {
        self.view.addSubview(tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(CoinListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.frame = view.frame
    }
    
    
    @objc func sortDidClicked(_ sender: AnyObject){
        if sender.titleLabel?.text == "Asc ↑" {
            sortButton.setTitle("Desc ↓", for: .normal)
            presenter.sort { $0.metrics.percent_change_usd_last_24_hours > $1.metrics.percent_change_usd_last_24_hours }
        } else {
            sortButton.setTitle("Asc ↑", for: .normal)
            presenter.sort { $0.metrics.percent_change_usd_last_24_hours < $1.metrics.percent_change_usd_last_24_hours }
        }
        tableView.reloadData()
    }
    

}

class CoinListTableViewCell: UITableViewCell {
    
    static let identifier = "CoinListTableViewCell"
        
    var slug: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 20)
        name.numberOfLines = 2
        return name
    }()
    
    let symbol = UILabel()

    var price_usd = UILabel()
    
    var percent_change_usd_last_24_hours = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(slug)
        addSubview(symbol)
        addSubview(price_usd)
        addSubview(percent_change_usd_last_24_hours)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        slug.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.width.equalTo(200)
        }
                
        symbol.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(slug.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
        }

        price_usd.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(25)
        }
        
        percent_change_usd_last_24_hours.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(price_usd.snp.bottom).offset(10)
        }
    }
}


// MARK: - UITableViewDataSource

extension CoinListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numbersOfRowInSection(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let title = UILabel()
        title.text = "Crypto currencies"
        title.font = UIFont.boldSystemFont(ofSize: 20)
        
        headerView.addSubview(title)
        headerView.addSubview(sortButton)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        sortButton.addTarget(self, action: #selector(sortDidClicked), for: .touchUpInside)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        sortButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        sortButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CoinListTableViewCell
        cell?.slug.text = presenter.coinSlugForRow(at: indexPath)
        cell?.symbol.text = presenter.coinSymbolForRow(at: indexPath)
        cell?.price_usd.text = presenter.coinPriceUsdForRow(at: indexPath)
        cell?.percent_change_usd_last_24_hours.text = presenter.coinPricePercentChangeUsdLast24HoursForRow(at: indexPath)
        return cell ?? UITableViewCell()
    }
    
 
    

}

// MARK: - UITableViewDelegate

extension CoinListViewController: UITableViewDelegate {

}

// MARK: - ColorListViewProtocol

extension CoinListViewController: CoinListViewProtocol {
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    

    func reloadTable() {
        tableView.reloadData()
    }

}
