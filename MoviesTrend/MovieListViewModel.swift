//
//  MovieListViewModel.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import Foundation

class MovieListViewModel {
    private var movies: [Movie] = []
    var updateHandler: (() -> Void)?

    func fetchTrendingMovies() {
        MovieService.getTrendingMovies { [weak self] movies in
            self?.movies = movies ?? []
            DispatchQueue.main.async {
                self?.updateHandler?()
            }
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
        movieDetailsViewModel.fetchMovieDetails { movieDetails in
            guard let movieDetails = movieDetails else {
                completion(nil)
                return
            }
            completion(movieDetailsViewModel)
        }
    }
}
