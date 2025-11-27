//
//  MoviesDetailViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    
    var viewModel: MoviesDetailViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieHeader: CustomHeaderView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadMovie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Bind ViewModel
    
   func bindViewModel() {
        
        viewModel.onMovieLoaded = { [weak self] movie in
            guard let self = self else { return }
            
            self.movieHeader.movieTitle.text = movie.Title
            self.movieHeader.genre.text = movie.Genre
            
            if let url = URL(string: movie.Poster ?? "") {
                self.movieHeader.moviePoster.load(url: url)
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UI Setup
    
   func setupUI() {
        tableView.register(
            UINib(nibName: DetailInfoTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: DetailInfoTableViewCell.identifier
        )
        
        tableView.register(
            UINib(nibName: CastAndCrewTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: CastAndCrewTableViewCell.identifier
        )
        
        tableView.register(
            UINib(nibName: RatingViewTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: RatingViewTableViewCell.identifier
        )
        
        tableView.register(
            UINib(nibName: RatingInfoTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: RatingInfoTableViewCell.identifier
        )
    }
    
    static func instance(with movie: MovieDetails) -> MoviesDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "MoviesDetailViewController"
        ) as! MoviesDetailViewController
        vc.viewModel = MoviesDetailViewModel(movie: movie)
        return vc
    }
    
    // MARK: - Button Action
    @IBAction func onTapRating(_ sender: UIButton) {
        let ratingVC = RatingViewController.instance()
        navigationController?.pushViewController(ratingVC, animated: true)
    }
}

// MARK: - TableView
extension MoviesDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 4 // info, cast/crew, IMDB rating, ratings breakdown
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = viewModel.movie
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailInfoTableViewCell.identifier,
                for: indexPath
            ) as! DetailInfoTableViewCell
            cell.configure(movie)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CastAndCrewTableViewCell.identifier,
                for: indexPath
            ) as! CastAndCrewTableViewCell
            cell.configure(movie)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RatingViewTableViewCell.identifier,
                for: indexPath
            ) as! RatingViewTableViewCell
            
            let rating = Double(movie.imdbRating ?? "0") ?? 0
            cell.configure(rating)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RatingInfoTableViewCell.identifier,
                for: indexPath
            ) as! RatingInfoTableViewCell
            cell.configure(movie)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
