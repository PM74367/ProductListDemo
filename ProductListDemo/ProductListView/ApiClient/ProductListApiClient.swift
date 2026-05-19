//
//  ProductListApiClient.swift
//  ProductListDemo
//
//  Created by Puneet on 08/05/26.
//

import Combine
import Foundation

final class ProductListApiClient {
    private let storageManager = StorageManager.shared
    private var subscriptions: Set<AnyCancellable> = []

    @Published var response: [ProductModel?] = []
    private let url = "https://raw.githubusercontent.com/PaulLavoine/iOS_technical_test/main/inteview_test.json"
        
    func getProducts() {
        if let cachedResponse = getResponseFromLocalStorage() {
            do {
                let productList = try JSONDecoder().decode(ProductListModel.self, from: cachedResponse)
                self.response = productList.products
            } catch {
                print(error)
            }
            return
        }
        let taskPublisher = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
        taskPublisher
            .retry(3)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in }, receiveValue: { output in
                do {
                    self.storageManager.save(data: output.data, fileName: "ProductListResponse")
                    let productList = try JSONDecoder().decode(ProductListModel.self, from: output.data)
                    self.response = productList.products
                } catch {
                    print(error)
                }
            }).store(in: &subscriptions)
    }
    
    func getResponseFromLocalStorage() -> Data? {
        return storageManager.read(fileName: "ProductListResponse")
    }
}
