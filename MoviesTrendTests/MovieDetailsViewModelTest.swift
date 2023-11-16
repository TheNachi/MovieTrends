//
//  MovieDetailsViewModelTest.swift
//  MoviesTrendTests
//
//  Created by Munachimso Ugorji on 11/16/23.
//

import XCTest
@testable import MoviesTrend

class MovieDetailsViewModelTests: XCTestCase {
    
    var viewModel: MovieDetailsViewModel!
    
    let movieDetails = MovieDetails(
        adult: false,
        backdrop_path: "",
        belongs_to_collection: MovieDetails.Collection(),
        budget: 1000000,
        genres: [MovieDetails.Genre(id: 1, name: "Action")],
        homepage: "http://mock.com",
        id: 1,
        imdb_id: "tt1234567",
        original_language: "en",
        original_title: "Mock Movie",
        overview: "Mock overview",
        popularity: 1.0,
        poster_path: "",
        production_companies: [MovieDetails.ProductionCompany(id: 1, logo_path: nil, name: "Mock Company", origin_country: "US")],
        production_countries: [MovieDetails.ProductionCountry(iso_3166_1: "US", name: "United States")],
        release_date: "2023-01-01",
        revenue: 10000000,
        runtime: 120,
        spoken_languages: [MovieDetails.SpokenLanguage(english_name: "English", iso_639_1: "en", name: "English")],
        status: "Released",
        tagline: "Mock Tagline",
        title: "Mock Movie",
        video: false,
        vote_average: 8.5,
        vote_count: 100
    )
    
    override func setUp() {
        super.setUp()
        viewModel = MovieDetailsViewModel(movieId: 1)
    }

    func testFetchMovieDetailsSuccess() {
        viewModel.handleSuccess(movieDetails: movieDetails)
        
        XCTAssertEqual(viewModel.getMovieDetails()?.title, "Mock Movie")
        XCTAssertEqual(viewModel.getMovieDetails()?.overview, "Mock overview")
        XCTAssertEqual(viewModel.getMovieDetails()?.genres.first?.name, "Action")
    }
    
    func testFetchMovieDetailsCompletionHandlerFailure() {
        let expectedError = NSError(domain: "test", code: 500, userInfo: nil)
        
        viewModel.fetchMovieDetails { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
            }
        }
    }
    
    
}
