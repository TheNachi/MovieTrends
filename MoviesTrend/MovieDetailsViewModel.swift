//
//  MovieDetailsViewModel.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import Foundation

class MovieDetailsViewModel {
    private let movieId: Int
    private var movieDetails: MovieDetails?

    init(movieId: Int) {
        self.movieId = movieId
    }

    func fetchMovieDetails(completion: @escaping (MovieDetails?) -> Void) {
        MovieService.getMovieDetails(movieId: movieId) { [weak self] movieDetails in
            self?.movieDetails = movieDetails
            completion(movieDetails)
        }
    }

    func getMovieDetails() -> MovieDetails? {
        return movieDetails
    }
}
