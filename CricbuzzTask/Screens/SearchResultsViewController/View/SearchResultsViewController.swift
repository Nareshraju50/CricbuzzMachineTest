//
//  SearchResultsViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ movieModel: MovieDetails)
}

final class SearchResultsViewController: UIViewController {
    
    // MARK: - ViewModel
    var viewModel = SearchResultsViewModel(movies: [])
    
    // MARK: - Delegate
    weak var delegate: SearchResultsViewControllerDelegate?
    
    // MARK: - UI
    let searchResultsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(
            UINib(nibName: AllMoviesTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: AllMoviesTableViewCell.identifier
        )
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchResultsTableView)
        searchResultsTableView.frame = view.bounds
        searchResultsTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.searchResultsTableView.reloadData()
            }
        }
        
        viewModel.onMovieSelected = { [weak self] movie in
            self?.delegate?.searchResultsViewControllerDidTapItem(movie)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AllMoviesTableViewCell.identifier,
            for: indexPath
        ) as? AllMoviesTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = viewModel.item(at: indexPath.row)
        cell.configure(movieDetail: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectMovie(at: indexPath.row)
    }
}
