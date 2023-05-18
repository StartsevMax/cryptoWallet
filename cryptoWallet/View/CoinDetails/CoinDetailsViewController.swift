//
//  CoinDetailsViewController.swift
//  cryptoWallet
//
//  Created by Maxim Startsev on 10.05.2023.
//

import UIKit

class CoinDetailsViewController: DefaultViewController {
    
    private var coinName: String
    
    private var coinData: CoinData? {
        didSet {
            setupUI()
            updateValues()
        }
    }
    
    private var presenter: PresenterProtocol?
    
    let createLabelWithText: (_ text: String) -> UILabel = { text in
        let label = UILabel()
        label.text = text
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    lazy var priceUsd = createLabelWithText("Price USD: ")
    lazy var priceBtc = createLabelWithText("Price BTC: ")
    lazy var priceEth = createLabelWithText("Price ETH: ")
    lazy var volumeLast24Hours = createLabelWithText("Volume last 24 hours: ")
    lazy var realVolumeLast24Hours = createLabelWithText("Real volume last 24 hours: ")
    lazy var volumeLast24HoursOverstatementMultiple = createLabelWithText("Volume last 24 hours overstatement multiple: ")
    lazy var percentChangeUsdLast1Hour = createLabelWithText("Percent change usd last 1 hour: ")
    lazy var percentChangeBtcLast1Hour = createLabelWithText("Percent change btc last 1 hour: ")
    lazy var percentChangeEthLast1Hour = createLabelWithText("Percent change eth last 1 hour: ")
    lazy var percentChangeUsdLast24Hours = createLabelWithText("Percent change usd last 24 hours: ")
    lazy var percentChangeBtcLast24Hours = createLabelWithText("Percent change btc last 24 hours: ")
    lazy var percentChangeEthLast24Hours = createLabelWithText("Percent change eth last 24 hours: ")

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(priceUsd)
        stackView.addArrangedSubview(priceBtc)
        stackView.addArrangedSubview(priceEth)
        stackView.addArrangedSubview(volumeLast24Hours)
        stackView.addArrangedSubview(realVolumeLast24Hours)
        stackView.addArrangedSubview(volumeLast24HoursOverstatementMultiple)
        stackView.addArrangedSubview(percentChangeUsdLast1Hour)
        stackView.addArrangedSubview(percentChangeBtcLast1Hour)
        stackView.addArrangedSubview(percentChangeEthLast1Hour)
        stackView.addArrangedSubview(percentChangeUsdLast24Hours)
        stackView.addArrangedSubview(percentChangeBtcLast24Hours)
        stackView.addArrangedSubview(percentChangeEthLast24Hours)
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

        
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()
    
    init(coinName: String) {
        self.coinName = coinName
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(40)
        }
    }
    
    private func updateValues() {
        guard let coinData = coinData else { return }
        priceUsd.text? += String(format: "\n%.10f", coinData.marketData.priceUsd)
        priceBtc.text? += String(format: "\n%.10f", coinData.marketData.priceBtc)
        priceEth.text? += String(format: "\n%.10f", coinData.marketData.priceEth)
        volumeLast24Hours.text? += String(format: "\n%.10f", coinData.marketData.volumeLast24Hours)
        realVolumeLast24Hours.text? += String(format: "\n%.10f", coinData.marketData.realVolumeLast24Hours)
        volumeLast24HoursOverstatementMultiple.text! += String(format: "\n%.10f", coinData.marketData.volumeLast24HoursOverstatementMultiple)
        percentChangeUsdLast1Hour.text? += String(format: "\n%.10f", coinData.marketData.percentChangeUsdLast1Hour)
        percentChangeBtcLast1Hour.text? += String(format: "\n%.10f", coinData.marketData.percentChangeBtcLast1Hour)
        percentChangeEthLast1Hour.text? += String(format: "\n%.10f", coinData.marketData.percentChangeEthLast1Hour)
        percentChangeUsdLast24Hours.text? += String(format: "\n%.10f", coinData.marketData.percentChangeUsdLast24Hours)
        percentChangeBtcLast24Hours.text? += String(format: "\n%.10f", coinData.marketData.percentChangeBtcLast24Hours)
        percentChangeEthLast24Hours.text? += String(format: "\n%.10f", coinData.marketData.percentChangeEthLast24Hours)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        title = coinName
        presenter = Presenter()
        presenter?.setView(self)
        presenter?.loadCoinData(coinName: coinName)
        setupActivityIndicator()
    }
}

extension CoinDetailsViewController: ViewProtocol {

    func success() {
        self.activityIndicator.stopAnimating()
        coinData = presenter?.getCoinData()
    }
    
    func failure(error: Error) {
        self.showAlert {
            self.presenter?.loadCoinData(coinName: self.coinName)
        } cancelAction: {
            self.activityIndicator.stopAnimating()
            self.view.addSubview(self.noDataLabel)
            self.noDataLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }

    }
}

