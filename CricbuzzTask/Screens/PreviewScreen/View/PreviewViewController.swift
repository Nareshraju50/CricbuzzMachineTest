//
//  PreviewViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

final class PreviewViewController: UIViewController {
    
    var viewModel: PreviewViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Factory
    static func instance(with movies: [MovieDetails]) -> PreviewViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "PreviewViewController"
        ) as! PreviewViewController
        vc.viewModel = PreviewViewModel(movies: movies)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        viewModel.loadMovies()
    }
    
    private func bindViewModel() {
        
        viewModel.onMoviesUpdated = { [weak self] in
            self?.navigationItem.title = "Movie List (\(self?.viewModel.numberOfItems() ?? 0))"
            self?.tableView.reloadData()
        }
        
        viewModel.onMovieSelected = { [weak self] movie in
            guard let self else { return }
            let vc = MoviesDetailViewController.instance(with: movie)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func configureUI() {
        tableView.register(
            UINib(nibName: AllMoviesTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: AllMoviesTableViewCell.identifier
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Filter",
            style: .plain,
            target: self,
            action: #selector(filterData)
        )
    }
    
    @objc private func filterData() {
        let alert = UIAlertController(
            title: "Select Sorting",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Ascending", style: .default) { _ in
            self.viewModel.sort(ascending: true)
        })
        
        alert.addAction(UIAlertAction(title: "Descending", style: .default) { _ in
            self.viewModel.sort(ascending: false)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - TableView
extension PreviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AllMoviesTableViewCell.identifier,
            for: indexPath
        ) as! AllMoviesTableViewCell
        
        cell.configure(movieDetail: viewModel.item(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectMovie(at: indexPath.row)
    }
}
