//
//  MoviesDetailViewModel.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import Foundation

class MoviesDetailViewModel {
    
    private(set) var movie: MovieDetails
    var onMovieLoaded: ((MovieDetails) -> Void)?
    
    init(movie: MovieDetails) {
        self.movie = movie
    }
    
    func loadMovie() {
        onMovieLoaded?(movie)
    }
}
