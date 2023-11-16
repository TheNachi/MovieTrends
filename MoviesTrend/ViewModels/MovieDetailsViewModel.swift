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
    
    func fetchMovieDetails(completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        MovieService.getMovieDetails(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                self?.handleSuccess(movieDetails: movieDetails)
                completion(result)
            case .failure:
                completion(result)
            }
            
        }
    }
    
    public func handleSuccess(movieDetails: MovieDetails) {
        self.movieDetails = movieDetails
        
    }
    
    func getMovieDetails() -> MovieDetails? {
        return movieDetails
    }
}
