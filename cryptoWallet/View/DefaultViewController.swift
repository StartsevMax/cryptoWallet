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
    
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No data"
        return label
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
    
    func showAlert(retryAction: @escaping () -> (), cancelAction: @escaping () -> ()){
        let alert =  UIAlertController.init(title: "Error", message: "Error loading coins data", preferredStyle: .alert)
        let retryAction = UIAlertAction.init(title: "Retry", style: .default) { _ in
            retryAction()
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { _ in
            cancelAction()
        }
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
