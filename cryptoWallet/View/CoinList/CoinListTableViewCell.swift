//
//  CoinListTableViewCell.swift
//  cryptoWallet
//
//  Created by Maxim Startsev on 01.05.2023.
//

import UIKit
import SnapKit

class CoinListTableViewCell: UITableViewCell {
    
    static let identifier = "CoinListTableViewCell"
        
    var name: UILabel = {
        let slug = UILabel()
        slug.numberOfLines = 2
        return slug
    }()
    
    let symbol: UILabel = {
        let symbol = UILabel()
        symbol.font = UIFont.boldSystemFont(ofSize: 20)
        return symbol
    }()

    var price_usd = UILabel()
    
    var percent_change_usd_last_24_hours = PercentChangeLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(name)
        addSubview(symbol)
        addSubview(price_usd)
        addSubview(percent_change_usd_last_24_hours)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        symbol.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.width.equalTo(200)
        }
                
        name.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(symbol.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
        }

        price_usd.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
        }
        
        percent_change_usd_last_24_hours.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(price_usd.snp.bottom).offset(10)
        }
    }
}

class PercentChangeLabel: UILabel {
    override var text: String? {        
        willSet {
            guard let newValue = newValue else { return }
            let firstCharacterIndex = String.Index(utf16Offset: 0, in: newValue)
            if newValue[firstCharacterIndex] == "+" {
                self.textColor = .systemGreen
            } else if newValue[firstCharacterIndex] == "-" {
                self.textColor = .systemRed
            }
        }
    }
}
