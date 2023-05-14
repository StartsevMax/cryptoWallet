//
//  DefaultViewController.swift
//  cryptoWallet
//
//  Created by Maxim Startsev on 11.05.2023.
//

import UIKit

class DefaultViewController: UIViewController {
    
    lazy var logoutBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logoutDidClicked))
        item.tintColor = .systemRed
        return item
    }()
    
    @objc func logoutDidClicked() {
        UserDefaults.standard.set(false, forKey: "isLogged")
        self.view.window?.rootViewController = LoginViewController()
        self.view.window?.makeKeyAndVisible()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.rightBarButtonItem = logoutBarItem
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
