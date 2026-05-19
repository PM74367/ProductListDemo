//
//  ProductListViewModel.swift
//  ProductListDemo
//
//  Created by Puneet on 08/05/26.
//


struct ProductListViewModel {
    let products: [ProductModel]
}

struct ProductListModel: Codable {
    let products: [ProductModel?]
}

struct ProductModel: Codable {
    let title: String?
    let description: String?
    let thumbnail: String?
    let image: String?
}
