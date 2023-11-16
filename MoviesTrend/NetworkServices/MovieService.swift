//
//  MovieService.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import Foundation

class MovieService {
    private static let baseURL = "https://api.themoviedb.org/3"
    
    private static let headers: [String: String] = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMzY2NmQ3Y2I5MzMwOTRhMmM1ZGJhNWQxZjk4MWVkMSIsInN1YiI6IjY1NTRhYzYzYWM0MTYxMDEzYjRhODQ5YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.QnHdWkP-e6wHMxh8iP53sJ1l4wNenzH0w0g3lFchUQ4"
    ]
    
    static func getTrendingMovies(page: Int, completion: @escaping (Result<MovieData, Error>) -> Void) {
        guard hasInternetAccess() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet access"])))
            return
        }

        guard let url = URL(string: "\(baseURL)/discover/movie?include_adult=false&include_video=false&language=en-US&page=\(page)&sort_by=popularity.desc") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let movieData = try decoder.decode(MovieData.self, from: data)
                    completion(.success(movieData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
    
    static func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        guard hasInternetAccess() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet access"])))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/movie/\(movieId)?language=en-US") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let movieDetails = try decoder.decode(MovieDetails.self, from: data)
                    completion(.success(movieDetails))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
    
    static func getImageURL(path: String) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }
    
    private static func hasInternetAccess() -> Bool {
        guard let url = URL(string: "https://www.google.com") else { return false }
        
        let semaphore = DispatchSemaphore(value: 0)
        var hasInternet = false

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)

        let task = URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                hasInternet = (httpResponse.statusCode == 200)
            }

            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: .now() + 5.0)

        return hasInternet
    }
}
