//
//  ProductListPresenter.swift
//  ProductListDemo
//
//  Created by Puneet on 08/05/26.
//

import Combine

final class ProductListPresenter {
    let networkManager = ProductListApiClient()
    @Published var viewModel: ProductListViewModel?
    private var subscriptions: Set<AnyCancellable> = []
    
    func viewLoaded() {
        setupSubscriptions()
        networkManager.getProducts()
    }
    
    private func setupSubscriptions() {
        networkManager.$response.sink(receiveValue: { value in
            self.viewModel = ProductListViewModel(products: value.compactMap({
                $0
            }).filter { product in
                if product.image?.isEmpty == false, product.thumbnail?.isEmpty == false {
                    return true
                }
                return false
            })
        }).store(in: &subscriptions)
    }
}
