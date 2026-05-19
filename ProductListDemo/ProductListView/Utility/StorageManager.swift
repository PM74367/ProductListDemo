//
//  StorageManager.swift
//  ProductListDemo
//
//  Created by Puneet on 08/05/26.
//


import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let fileManager = FileManager.default

    private init() {}
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    @discardableResult func save(data: Data, fileName: String) -> Bool {
        let url = documentsDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: url, options: .atomic)
            return true
        } catch {
            return false
        }
    }

    func read(fileName: String) -> Data? {
        let url = documentsDirectory.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try? Data(contentsOf: url)
    }

    func delete(fileName: String) {
        let url = documentsDirectory.appendingPathComponent(fileName)
        try? fileManager.removeItem(at: url)
    }
}
