//
//  LoginViewController.swift
//  cryptoWallet
//
//  Created by Максим Старцев on 24.04.2023.
//

import UIKit

enum Credentials {
    static let login = "1234"
    static let password = "1234"
}

class LoginViewController: UIViewController {
    
    var login = ""
    
    var password = ""
    
    lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "Login"
        loginLabel.font = UIFont.systemFont(ofSize: 20)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()

    lazy var loginTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.borderStyle = .roundedRect
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        return loginTextField
    }()
    
    lazy var passwordLabel: UILabel = {
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont.systemFont(ofSize: 20)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        return passwordLabel
    }()

    lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(loginLabel)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordLabel)
        stackView.addArrangedSubview(passwordTextField)
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupViews() {
        loginTextField.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }
    
    @objc func loginDidChange(_ loginTextField: UITextField) {
        login = loginTextField.text ?? ""
    }
    
    @objc func passwordDidChange(_ passwordTextField: UITextField) {
        password = passwordTextField.text ?? ""
    }
    
    @objc func loginDidClick(_ passwordTextField: UITextField) {
        if login == Credentials.login && password == Credentials.password {
            let coinListTableViewController = CoinListViewController()
            self.view.window?.rootViewController = coinListTableViewController
            self.view.window?.makeKeyAndVisible()
            UserDefaults.standard.set(true, forKey: "isLogged")
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(loginButton)
        loginTextField.addTarget(self, action: #selector(loginDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginDidClick(_:)), for: .touchUpInside)
        setupViews()
    }
}
