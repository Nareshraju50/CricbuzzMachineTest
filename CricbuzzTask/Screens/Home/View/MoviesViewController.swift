//
//  MoviesViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

 class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = MoviesViewModel()
    private var filteredMovies: [MovieDetails] = []
    
     private let searchController: UISearchController = {
         let controller = UISearchController(searchResultsController: SearchResultsViewController())
         controller.searchBar.placeholder = Home.searchPlaceholderText
         controller.searchBar.searchBarStyle = .minimal
         return controller
     }()
    
    // MARK: - Lifecycle
     
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Categories"
        navigationSetUp()
        setupTableView()
        setupSearch()
        bindViewModel()
        
        viewModel.loadMovies()
    }
    
    // MARK: - UI Setup
    private func navigationSetUp() {
        let nav = UINavigationBarAppearance()
        nav.configureWithOpaqueBackground()
        nav.backgroundColor = UIColor(named: Colors.primeColor)
        nav.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = nav
        navigationItem.scrollEdgeAppearance = nav
        navigationItem.compactAppearance = nav
    }
    
    private func setupTableView() {
        view.backgroundColor = UIColor(named: Colors.primeColor)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: Home.cellConstant)
        
        tableView.register(CollapsibleTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: Home.header)
        
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        
        viewModel.onMoviesUpdated = { [weak self] in
            self?.filteredMovies = self?.viewModel.filteredMovies ?? []
        }
        
        viewModel.onSectionsUpdated = { [weak self] in
            DispatchQueue.main.async { self?.tableView.reloadData() }
        }
        
        viewModel.onFilteredMoviesUpdated = { [weak self] in
            self?.filteredMovies = self?.viewModel.filteredMovies ?? []
        }
        
        viewModel.onError = { message in
            print("❌ Error:", message)
        }
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Home.cellConstant,
            for: indexPath
        )
        
        cell.textLabel?.text = viewModel.itemTitle(at: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Home.header
        ) as? CollapsibleTableViewHeader
        ?? CollapsibleTableViewHeader(reuseIdentifier: Home.header)
        
        header.titleLabel.text = viewModel.titleForSection(section)
        header.arrowLabel.text = ">"
        header.setCollapsed(collapsed: viewModel.isSectionCollapsed(section))
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        viewModel.isSectionCollapsed(indexPath.section)
            ? 0
            : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let movies = viewModel.moviesForSectionItem(at: indexPath)
        
        let previewVC = PreviewViewController.instance(with: movies)
        navigationController?.pushViewController(previewVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MoviesViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        
        if section == MovieSections.allMovies.rawValue {
            let movies = viewModel.allMoviesList()
            let previewVC = PreviewViewController.instance(with: movies)
            navigationController?.pushViewController(previewVC, animated: true)
            return
        }
        
        viewModel.toggleSection(at: section)
        tableView.reloadSections([section], with: .automatic)
    }
    
    func callHeader(index: Int) {
        viewModel.toggleSection(at: index)
        tableView.reloadSections([index], with: .automatic)
    }
}

extension MoviesViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        let filtered = viewModel.search(query: query)
        filteredMovies = filtered
        
        resultsController.delegate = self
        resultsController.viewModel.updateMovies(filtered)
    }
    
    func searchResultsViewControllerDidTapItem(_ movieModel: MovieDetails) {
        let movieDetailVC = MoviesDetailViewController.instance(with: movieModel)
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
