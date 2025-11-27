//
//  PreviewViewModel.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import Foundation

final class PreviewViewModel {
    
    // MARK: - Data
    private(set) var movies: [MovieDetails]
    
    // MARK: - Bindings
    var onMoviesUpdated: (() -> Void)?
    var onMovieSelected: ((MovieDetails) -> Void)?
    
    // MARK: - Init
    init(movies: [MovieDetails]) {
        self.movies = movies
    }
    
    // MARK: - Lifecycle hook (used by VC)
    func loadMovies() {
        // Just notify that data is ready
        onMoviesUpdated?()
    }
    
    // MARK: - Table helpers
    func numberOfItems() -> Int {
        return movies.count
    }
    
    func item(at index: Int) -> MovieDetails {
        return movies[index]
    }
    
    func selectMovie(at index: Int) {
        let movie = movies[index]
        onMovieSelected?(movie)
    }

    func sort(ascending: Bool) {
        movies.sort { m1, m2 in
            if m1.Title == m2.Title {
                return ascending ? m1.Year < m2.Year : m1.Year > m2.Year
            }
            return ascending ? m1.Title < m2.Title : m1.Title > m2.Title
        }
        onMoviesUpdated?()
    }
}
