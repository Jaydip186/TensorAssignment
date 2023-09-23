//
//  ProfileViewModel.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import Foundation

import Foundation

import Foundation

class ProfileViewModel {
    private let networkManager = NetworkManager.shared

    func fetchWeatherData(for cityLatitide: String, cityLogitude: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let apiUrl = "\(Base_url)?lat=\(cityLatitide)&lon=\(cityLogitude)&exclude=hourly,minutely&appid=\(apiKey)"

        if let encodedURLString = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let encodedURL = URL(string: encodedURLString) {
            print("Encoded URL: \(encodedURL)")
            networkManager.fetchData(from: encodedURL) { data, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
            
        } else {
            print("Failed to encode URL.")
        }
        
        
        
    }
}

