//
//  MovieListViewModelTests.swift
//  MoviesTrendTests
//
//  Created by Munachimso Ugorji on 11/16/23.
//

import XCTest
@testable import MoviesTrend

final class MovieListViewModelTests: XCTestCase {
    
    let viewModel = MovieListViewModel()

    let movieData = MovieData(
        page: 1,
        results: [Movie(adult: false, backdrop_path: "", genre_ids: [1], id: 1, original_language: "en", original_title: "Mock Movie 1", overview: "Mock overview 1", popularity: 1.0, poster_path: "", release_date: "2023-01-01", title: "Mock Movie 1", video: false, vote_average: 1.0, vote_count: 1)],
        total_pages: 1,
        total_results: 1
    )

    func testFetchTrendingMoviesSuccess() {
        

        viewModel.handleSuccess(movieData: movieData)

        XCTAssertFalse(viewModel.movies.isEmpty)
        XCTAssertEqual(viewModel.numberOfMovies(), 1)

        let movie = viewModel.movie(at: 0)
        XCTAssertEqual(movie.title, "Mock Movie 1")
        XCTAssertEqual(movie.overview, "Mock overview 1")

    }

    func testFetchTrendingMoviesFailure() {

        let error = NSError(domain: "test", code: 500, userInfo: nil)

        viewModel.handleError(error: error)

        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertEqual(viewModel.numberOfMovies(), 0)

    }

    func testDidSelectMovie() {


        viewModel.handleSuccess(movieData: movieData)

        XCTAssertFalse(viewModel.movies.isEmpty)

        let indexPath = IndexPath(row: 0, section: 0)

        viewModel.didSelectMovie(at: indexPath) { movieDetailsViewModel in
            XCTAssertNotNil(movieDetailsViewModel)

        }
    }

    func testPagination() {

        let movieData1 = MovieData(
            page: 1,
            results: [Movie(adult: false, backdrop_path: "", genre_ids: [1], id: 1, original_language: "en", original_title: "Mock Movie 1", overview: "Mock overview 1", popularity: 1.0, poster_path: "", release_date: "2023-01-01", title: "Mock Movie 1", video: false, vote_average: 1.0, vote_count: 1)],
            total_pages: 2,
            total_results: 2
        )

        let movieData2 = MovieData(
            page: 2,
            results: [Movie(adult: false, backdrop_path: "", genre_ids: [1], id: 2, original_language: "en", original_title: "Mock Movie 2", overview: "Mock overview 2", popularity: 1.0, poster_path: "", release_date: "2023-01-02", title: "Mock Movie 2", video: false, vote_average: 2.0, vote_count: 2)],
            total_pages: 2,
            total_results: 2
        )

        viewModel.handleSuccess(movieData: movieData1)
        XCTAssertEqual(viewModel.numberOfMovies(), 1)

        viewModel.fetchTrendingMovies()

        viewModel.handleSuccess(movieData: movieData2)
        XCTAssertEqual(viewModel.numberOfMovies(), 2)

    }
}
