//
//  SearchResultsViewModel.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import Foundation

final class SearchResultsViewModel {
    
    private(set) var movies: [MovieDetails]
    
    var onMoviesUpdated: (() -> Void)?
    var onMovieSelected: ((MovieDetails) -> Void)?
    
    init(movies: [MovieDetails]) {
        self.movies = movies
    }
    
    func numberOfItems() -> Int {
        movies.count
    }
    
    func item(at index: Int) -> MovieDetails {
        movies[index]
    }
    
    func selectMovie(at index: Int) {
        let movie = movies[index]
        onMovieSelected?(movie)
    }
    
    func updateMovies(_ newMovies: [MovieDetails]) {
        movies = newMovies
        onMoviesUpdated?()
    }
}
