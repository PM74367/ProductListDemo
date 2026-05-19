//
//  ProductListViewController.swift
//  ProductListDemo
//
//  Created by Puneet on 08/05/26.
//

import Foundation
import UIKit
import Combine

class ProductListViewController: UIViewController {

    private let tableView: UITableView = UITableView()
    private let searchBar: UISearchBar = UISearchBar()
    private let randomSelectionButton: UIButton = UIButton()

    private let presenter = ProductListPresenter()
    private var subscriptions: Set<AnyCancellable> = []
    
    var viewModel: ProductListViewModel? {
        didSet {
            applyModel()
        }
    }
    
    var filteredProducts: [ProductModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        setupView()
        presenter.viewLoaded()
    }
    
    private func setupSubscriptions() {
        presenter.$viewModel.sink(receiveValue: { value in
            self.viewModel = value
        }).store(in: &subscriptions)
    }

    private func setupView() {
        setupTableView()
        setupSearchBar()
        setupRandomButton()
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        self.view.addSubview(randomSelectionButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        randomSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            randomSelectionButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            randomSelectionButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            randomSelectionButton.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -16.0),
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: ProductListTableViewCell.reuseIdentifier)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupRandomButton() {
        randomSelectionButton.setTitleColor(.black, for: .normal)
        randomSelectionButton.setTitle("Surprise me", for: .normal)
        randomSelectionButton.addTarget(self, action: #selector(randomSelectionButtonTapped), for: .touchUpInside)
    }

    private func applyModel() {
        filteredProducts = viewModel?.products ?? []
        tableView.reloadData()
    }
    
    @objc private func randomSelectionButtonTapped() {
        guard let randomItem = filteredProducts.randomElement() else { return }
        navigateToItemDetail(with: randomItem)
    }
    
    private func navigateToItemDetail(with model: ProductModel) {
        let detailsViewController = ProductDetailViewController()
        detailsViewController.viewModel = ProductDetailViewModel(
            imageUrl: model.image,
            title: model.title,
            description: model.description
        )
        present(detailsViewController, animated: true)
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.reuseIdentifier, for: indexPath) as? ProductListTableViewCell else { return UITableViewCell() }
        cell.viewModel = filteredProducts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = filteredProducts[indexPath.row]
        navigateToItemDetail(with: model)
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = viewModel?.products ?? []
        } else {
            filteredProducts = viewModel?.products.filter {
                return $0.title?.contains(searchText) ?? false
            } ?? []
        }
        tableView.reloadData()
    }
}

