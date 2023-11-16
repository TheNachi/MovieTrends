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
        
        viewModel.errorHandler = { [weak self] error in
            self?.showErrorAlert(error: error)
        }
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        viewModel.didSelectMovie(at: indexPath) { [weak self] movieDetailsViewModel in
            guard let movieDetailsViewModel = movieDetailsViewModel else {
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
    
    private func showErrorAlert(error: Error?) {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Unknown Error", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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

        if indexPath.row == viewModel.numberOfMovies() - 1 {
            viewModel.fetchTrendingMovies()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectMovie(at: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            viewModel.fetchTrendingMovies()
        }
    }
}
