//
//  Service.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

protocol MoviesServiceProtocol {
    func fetchMovieDetails(
        urlString: String,
        completion: @escaping (Result<[MovieDetails], DataError>) -> Void
    )
}

final class MoviesService: MoviesServiceProtocol {
    
    func fetchMovieDetails(
        urlString: String,
        completion: @escaping (Result<[MovieDetails], DataError>) -> Void
    ) {
        
        guard let url = Bundle.main.url(forResource: urlString, withExtension: "json") else {
            completion(.failure(.invalidURL))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MovieDetails].self, from: data)
            completion(.success(jsonData))
        } catch {
            completion(.failure(.network(error)))
        }
    }
}
