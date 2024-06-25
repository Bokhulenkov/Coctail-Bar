//
//  ViewController.swift
//  Coctail Bar
//
//  Created by Alexander Bokhulenkov on 25.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 25)
        textField.placeholder = "Search coctail"
        textField.textAlignment = .right
        textField.backgroundColor = .systemFill
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var recipesLabel: UILabel = {
        let label = UILabel()
        label.text = "some text"
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 30, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setConstraints()
        
    }
    
    // MARK: - Selectors
    
    @objc private func searchPressed() {
        print("Tap search Button")
    }

    // MARK: - Setup View
    
    func setView() {
        view.backgroundColor = .white
        
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(headerStackView)
        
        headerStackView.addArrangedSubview(searchTextField)
        headerStackView.addArrangedSubview(searchButton)
        
        mainStackView.addArrangedSubview(recipesLabel)
        
    }

}

// MARK: - Extensions Constraints

extension ViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            headerStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40)
            
            
            
        ])
    }
}
