//
//  ProductListTableViewCell.swift
//  ProductListDemo
//
//  Created by Puneet on 08/05/26.
//

import UIKit

final class ProductListTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ProductListTableViewCell"
    let label = UILabel()
    let imgView = RemoteImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        label.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints =  false
        self.contentView.addSubview(label)
        self.contentView.addSubview(imgView)
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: 44.0),
            imgView.heightAnchor.constraint(equalToConstant: 44.0),
            imgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            imgView.trailingAnchor.constraint(equalTo: self.label.leadingAnchor, constant: -8.0),
            imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.0),
            imgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0),
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16.0)
        ])
    }
    var viewModel: ProductModel? {
        didSet {
            applyModel()
        }
    }
    
    private func applyModel() {
        guard let viewModel else { return }
        self.label.text = viewModel.title
        imgView.downloadImage(from: URL(string: viewModel.thumbnail!)!)
    }
}
