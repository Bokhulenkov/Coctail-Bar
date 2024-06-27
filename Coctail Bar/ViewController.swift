//
//  ViewController.swift
//  Coctail Bar
//
//  Created by Alexander Bokhulenkov on 25.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fone")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
    
    private lazy var recipesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let emptyView = UIView()
    
    private var coctailManager = CoctailManager()
    
    // MARK: - Temp Storage
    
    //    массив для хранения ингредиентов
    private var ingredients: [String] = []
    private var instraction = ""
    private var coctailName: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setConstraints()
        
        recipesTable.register(IngredientsCell.self, forCellReuseIdentifier: IngredientsCell.identifier)
        recipesTable.register(InstructionsCell.self, forCellReuseIdentifier: InstructionsCell.identifier)
        
        coctailManager.delegate = self
        searchTextField.delegate = self
        recipesTable.delegate = self
        recipesTable.dataSource = self
        
    }
    
    // MARK: - Selectors
    
    @objc private func searchPressed() {
        searchTextField.endEditing(true)
    }
    
    // MARK: - Setup View
    
    private func setView() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(headerStackView)
        
        headerStackView.addArrangedSubview(searchTextField)
        headerStackView.addArrangedSubview(searchButton)
        
        mainStackView.addArrangedSubview(emptyView)
        mainStackView.addArrangedSubview(recipesTable)
        

    }
    
    // MARK: - Private Funk
    private func createAttributedText(for string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(white: 0, alpha: 0.3) // Легкий серый цвет
        shadow.shadowOffset = CGSize(width: 1, height: 3) // Легкое смещение
        shadow.shadowBlurRadius = 5.0 // Небольшое размытие
        
        attributedString.addAttribute(.shadow, value: shadow, range: NSRange(location: 0, length: string.count))
        
        return attributedString
    }
    
}

// MARK: - Extensions Constraints

extension ViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
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

// MARK: - Extensions TextField

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty {
            textField.placeholder = "Search coctail"
            return true
        } else {
            textField.placeholder = "type some coctail name..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let coctailName = searchTextField.text {
            coctailManager.performRequest(coctailName)
        }
    }
}

// MARK: - Extensions CoctailManagerDelegate

extension ViewController: CoctailManagerDelegate {
    func didReceivCoctail(_ coctailManager: CoctailManager, coctailData: CoctailData) {
        DispatchQueue.main.async {
            self.coctailName = coctailData.name
            self.ingredients = coctailData.ingredients
            self.instraction = coctailData.instructions
            
            self.recipesTable.reloadData() // Перезагрузка таблицы для отображения новых данных
            
        }
    }
    
    func didFailWithError(error: Error) {
        print("We have parse error: \(error)")
    }
}

// MARK: - Extensions TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < ingredients.count {
            
            let rule = ingredients[indexPath.row]
            let cellIdentifier = IngredientsCell.identifier
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? IngredientsCell else {
                return UITableViewCell()
                
            }
            cell.configureCell(description: createAttributedText(for: rule))
            cell.selectionStyle = .none
            return cell } else {
                let cellIdentifier = InstructionsCell.identifier
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? InstructionsCell else {
                    return UITableViewCell()
                }
                cell.configureCell(instructions: createAttributedText(for: instraction))
                cell.selectionStyle = .none
                return cell
            }
    }
    
//   создание заголовка c названием коктеля
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.text = coctailName?.uppercased()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
//    высота секции с заголовком
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
}
