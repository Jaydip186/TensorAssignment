//
//  NetworkManager.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }.resume()
    }
}
