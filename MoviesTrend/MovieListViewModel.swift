//
//  MovieListViewModel.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import Foundation

class MovieListViewModel {
    private var movies: [Movie] = []
    private var currentPage = 1
    private var totalPages = 1
    
    var updateHandler: (() -> Void)?
    var errorHandler: ((Error?) -> Void)?
    
    func fetchTrendingMovies() {
        guard currentPage <= totalPages else {
            return
        }
        
        MovieService.getTrendingMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let movieData):
                self?.handleSuccess(movieData: movieData)
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    private func handleSuccess(movieData: MovieData) {
        self.movies.append(contentsOf: movieData.results)
        self.totalPages = movieData.total_pages
        self.currentPage += 1
        
        DispatchQueue.main.async {
            self.updateHandler?()
        }
    }
    
    private func handleError(error: Error) {
        DispatchQueue.main.async {
            self.errorHandler?(error)
        }
    }
    
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    func didSelectMovie(at indexPath: IndexPath, completion: @escaping (MovieDetailsViewModel?) -> Void) {
        let selectedMovie = movie(at: indexPath.row)
        let movieDetailsViewModel = MovieDetailsViewModel(movieId: selectedMovie.id)
        movieDetailsViewModel.fetchMovieDetails { result in
            switch result {
            case .success:
                completion(movieDetailsViewModel)
            case .failure(let error):
                self.handleError(error: error)
            }

            
        }
    }
}
