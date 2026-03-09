//
//  CityController.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 27.02.26.
//

import UIKit
import SnapKit

// MARK: - Protocols
protocol ICityView: AnyObject {
    func displaySearchResults(_ cities: [CityInfo])
    func displaySavedCities(_ cities: [CityInfo])
}

// MARK: - CityController
final class CityController: UIViewController, ICityView {
    
    // MARK: - UI Elements
    private let citySearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = CityControllerConstants.Strings.searchBarPlaceholder
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = CityControllerConstants.Colors.searchBarTint
        searchBar.tintColor = CityControllerConstants.Colors.searchBarTint
        searchBar.searchTextField.textColor = CityControllerConstants.Colors.searchBarText
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private lazy var cityTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CitiesViewCell.self, forCellReuseIdentifier: CitiesViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = CityControllerConstants.Colors.tableViewBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorColor = CityControllerConstants.Colors.tableViewSeparator
        return tableView
    }()
    
    // MARK: - Properties
    private let presenter: ICityPresenter
    private var searchResults: [CityInfo] = []
    private var savedCities: [CityInfo] = []
    
    // MARK: - Initialization
    init(presenter: ICityPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegates()
        presenter.viewDidLoad()
    }
    
    // MARK: - UI Configuration
    func configureUI() {
        view.backgroundColor = CityControllerConstants.Colors.background
        title = CityControllerConstants.Strings.title
        
        navigationController?.navigationBar.barTintColor = CityControllerConstants.Colors.navigationBarTint
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: CityControllerConstants.Colors.navigationBarTitle
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: CityControllerConstants.Strings.closeButtonImageName),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(citySearchBar)
        citySearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(CityControllerConstants.Layout.searchBarTopOffset)
            make.left.equalToSuperview().offset(CityControllerConstants.Layout.searchBarHorizontalOffset)
            make.right.equalToSuperview().inset(CityControllerConstants.Layout.searchBarHorizontalOffset)
            make.height.equalTo(CityControllerConstants.Layout.searchBarHeight)
        }
        
        view.addSubview(cityTableView)
        cityTableView.snp.makeConstraints { make in
            make.top.equalTo(citySearchBar.snp.bottom).offset(CityControllerConstants.Layout.tableViewTopOffset)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupDelegates() {
        citySearchBar.delegate = self
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - ICityView Methods
    func displaySearchResults(_ cities: [CityInfo]) {
        searchResults = cities
        cityTableView.reloadData()
    }
    
    func displaySavedCities(_ cities: [CityInfo]) {
        savedCities = cities
        cityTableView.reloadData()
    }
    
    // MARK: - Alert Methods
    private func showDeleteConfirmation(for city: CityInfo, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: CityControllerConstants.Strings.deleteConfirmationTitle,
            message: CityControllerConstants.Strings.deleteConfirmationMessage,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: CityControllerConstants.Strings.cancelButtonTitle, style: .cancel)
        let deleteAction = UIAlertAction(title: CityControllerConstants.Strings.deleteButtonTitle, style: .destructive) { [weak self] _ in
            self?.presenter.deleteCity(city)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CityController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.isEmpty ? savedCities.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CitiesViewCell.identifier,
            for: indexPath
        ) as? CitiesViewCell else {
            return UITableViewCell()
        }
        
        let city: CityInfo
        if !searchResults.isEmpty {
            city = searchResults[indexPath.row]
        } else {
            city = savedCities[indexPath.row]
        }
        
        cell.configure(with: city.displayedNameString)
        cell.backgroundColor = CityControllerConstants.Colors.tableViewBackground
        cell.textLabel?.textColor = CityControllerConstants.Colors.cellText
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let city: CityInfo
        if !searchResults.isEmpty {
            city = searchResults[indexPath.row]
        } else {
            city = savedCities[indexPath.row]
        }
        
        presenter.didSelectCity(city)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CityControllerConstants.Layout.cellHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return searchResults.isEmpty
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard searchResults.isEmpty else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: CityControllerConstants.Strings.deleteButtonTitle) { [weak self] (_, _, completion) in
            let city = self?.savedCities[indexPath.row]
            if let city = city {
                self?.showDeleteConfirmation(for: city, at: indexPath)
            }
            completion(true)
        }
        deleteAction.image = UIImage(systemName: CityControllerConstants.Strings.deleteImageName)
        deleteAction.backgroundColor = CityControllerConstants.Colors.deleteAction
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UISearchBarDelegate
extension CityController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
            cityTableView.reloadData()
        } else {
            presenter.searchCity(query: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchResults = []
        cityTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
