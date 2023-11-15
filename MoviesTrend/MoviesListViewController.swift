//
//  ViewController.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movie Trends"
        setupUI()
        setupViewModel()
        viewModel.fetchTrendingMovies()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.updateHandler = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        viewModel.didSelectMovie(at: indexPath) { [weak self] movieDetailsViewModel in
            guard let movieDetailsViewModel = movieDetailsViewModel else {
                // Handle error or display an alert
                return
            }
            DispatchQueue.main.async {
                self?.navigateToMovieDetails(movieDetailsViewModel)
            }
        }
    }
    
    private func navigateToMovieDetails(_ movieDetailsViewModel: MovieDetailsViewModel) {
        let movieDetailsVC = MovieDetailsViewController(viewModel: movieDetailsViewModel)
        
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let movie = viewModel.movie(at: indexPath.row)
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectMovie(at: indexPath)
    }
}
