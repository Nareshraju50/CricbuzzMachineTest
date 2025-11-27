//
//  HomeViewModel.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import Foundation
import UIKit

final class MoviesViewModel {
    
    // MARK: - Dependencies
    private let service: MoviesServiceProtocol
    
    private(set) var movies: [MovieDetails] = []
    private(set) var sections: [Section<Any>] = []
    private(set) var filteredMovies: [MovieDetails] = []
    
    var onMoviesUpdated: (() -> Void)?
    var onSectionsUpdated: (() -> Void)?
    var onFilteredMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Init
    
    init(service: MoviesServiceProtocol = MoviesService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    
    func loadMovies() {
        service.fetchMovieDetails(urlString: Home.fileNameString) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                self?.movies = movieDetails
                self?.buildSections(from: movieDetails)
                self?.onMoviesUpdated?()
            case .failure(let error):
                self?.onError?("Failed to load movies: \(error)")
            }
        }
    }
    
    func toggleSection(at index: Int) {
        guard sections.indices.contains(index) else { return }
        sections[index].collapse.toggle()
        onSectionsUpdated?()
    }
    
    func numberOfSections() -> Int {
        sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].collapse ? 0 : sections[section].listData.count
    }
    
    func titleForSection(_ section: Int) -> String {
        guard sections.indices.contains(section) else { return "" }
        return sections[section].title
    }
    
    func itemTitle(at indexPath: IndexPath) -> String? {
        guard sections.indices.contains(indexPath.section),
              sections[indexPath.section].listData.indices.contains(indexPath.row) else {
            return nil
        }
        return sections[indexPath.section].listData[indexPath.row] as? String
    }
    
    func isSectionCollapsed(_ section: Int) -> Bool {
        guard sections.indices.contains(section) else { return true }
        return sections[section].collapse
    }
    
    func moviesForSectionItem(at indexPath: IndexPath) -> [MovieDetails] {
        
        guard let sectionType = MovieSections(rawValue: indexPath.section),
              sections.indices.contains(indexPath.section),
              let compareValue = sections[indexPath.section].listData[indexPath.row] as? String else {
            filteredMovies = []
            onFilteredMoviesUpdated?()
            return []
        }
        
        switch sectionType {
        case .year:
            filteredMovies = movies.filter {
                $0.Year.components(separatedBy: Home.hyphen).contains(compareValue)
            }
            
        case .genre:
            filteredMovies = movies.filter {
                $0.Genre.components(separatedBy: Home.comma).contains(compareValue)
            }
            
        case .directors:
            filteredMovies = movies
                .filter { $0.Director.components(separatedBy: Home.comma).contains(compareValue) }
                .sorted()
            
        case .actors:
            filteredMovies = movies.filter {
                $0.Actors.components(separatedBy: Home.comma).contains(compareValue)
            }
            
        case .allMovies:
            filteredMovies = movies
        }
        
        onFilteredMoviesUpdated?()
        return filteredMovies
    }

    
    /// Used when user taps “All Movies” section header directly
    func allMoviesList() -> [MovieDetails] {
        filteredMovies = movies
        onFilteredMoviesUpdated?()
        return movies
    }
    
    /// Search logic
    func search(query: String) -> [MovieDetails] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty,
              trimmed.count >= Home.minimumSearchLimit else {
            filteredMovies = []
            onFilteredMoviesUpdated?()
            return []
        }
        
        filteredMovies = movies.filter { movie in
            let lower = trimmed.lowercased()
            return movie.Title.lowercased().contains(lower) ||
                   movie.Genre.lowercased().contains(lower) ||
                   movie.Director.lowercased().contains(lower) ||
                   movie.Actors.lowercased().contains(lower)
        }
        
        onFilteredMoviesUpdated?()
        return filteredMovies
    }
    
    // MARK: - Private Helpers
    
    private func buildSections(from movieDetails: [MovieDetails]) {
        let yearArray = Set(movieDetails.map { $0.Year })
        let genreArray = Set(movieDetails.map { $0.Genre })
        let actors =  Set(movieDetails.map { $0.Actors })
        let directors = Set(movieDetails.map { $0.Director })
        let allMovies = movieDetails
        
        let genresArray = Array(genreArray).sorted()
        let splitGenres = genresArray
            .flatMap { $0.components(separatedBy: Home.comma) }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let actorsArray = Array(actors).sorted()
        let splitActors = actorsArray
            .flatMap { $0.components(separatedBy: Home.comma) }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let directorsArray = Array(directors).sorted()
        let splitDirectors = directorsArray
            .flatMap { $0.components(separatedBy: Home.comma) }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        var movieDatabaseList = [Section<Any>]()
        movieDatabaseList.append(Section(title: Home.year,
                                         collapse: true,
                                         listData: yearArray.sorted()))
        movieDatabaseList.append(Section(title: Home.genre,
                                         collapse: true,
                                         listData: splitGenres))
        movieDatabaseList.append(Section(title: Home.directors,
                                         collapse: true,
                                         listData: splitDirectors))
        movieDatabaseList.append(Section(title: Home.actors,
                                         collapse: true,
                                         listData: splitActors))
        movieDatabaseList.append(Section(title: Home.allMovies,
                                         collapse: true,
                                         listData: allMovies))
        
        sections = movieDatabaseList
        onSectionsUpdated?()
    }
}
