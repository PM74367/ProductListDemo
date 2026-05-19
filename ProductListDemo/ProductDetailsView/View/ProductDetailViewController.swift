//
//  ProductDetailViewController.swift
//  ProductListDemo
//
//  Created by Puneet on 08/05/26.
//

import UIKit

struct ProductDetailViewModel {
    let imageUrl: String?
    let title: String?
    let description:  String?
}

final class ProductDetailViewController: UIViewController {
    let imageView = RemoteImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    var viewModel: ProductDetailViewModel? {
        didSet {
            applyModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints =  false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }

    private func applyModel() {
        guard let viewModel else { return }
        imageView.downloadImage(from: URL(string: viewModel.imageUrl!)!)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
