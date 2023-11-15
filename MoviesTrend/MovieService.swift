//
//  MovieService.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import Foundation

class MovieService {
    
    private static let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3"
    private static let baseURL = "https://api.themoviedb.org/3"
    
    private static let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMzY2NmQ3Y2I5MzMwOTRhMmM1ZGJhNWQxZjk4MWVkMSIsInN1YiI6IjY1NTRhYzYzYWM0MTYxMDEzYjRhODQ5YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.QnHdWkP-e6wHMxh8iP53sJ1l4wNenzH0w0g3lFchUQ4"
    ]
    
    private static var movieCache: [String: Any] = [:]
    
    static func getTrendingMovies(completion: @escaping ([Movie]?) -> Void) {
        guard hasInternetAccess() else {
            // Handle no internet access
            completion(nil)
            return
        }
        
        if let cachedMovies = movieCache["trendingMovies"] as? [Movie] {
            completion(cachedMovies)
            return
        }
        
        guard let url = URL(string: "\(baseURL)/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // ... (rest of the code remains the same)
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let movieData = try decoder.decode(MovieData.self, from: data)
                            movieCache["trendingMovies"] = movieData.results
                            completion(movieData.results)
                        
                    } catch {
                        print("error decoding json")
                    }
                }
            }
            
        }
        dataTask.resume()
    }
    
    static func getMovieDetails(movieId: Int, completion: @escaping (MovieDetails?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/872585?language=en-US")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {

              if let data = data {
                  let decoder = JSONDecoder()
                  do {
                      let movieDetails = try decoder.decode(MovieDetails.self, from: data)
                      completion(movieDetails)
                  } catch let decodingError {
                      print("error decoding json: \(decodingError)")
                  }
              }
          }
        })

        dataTask.resume()
    }
    
    static func getImageURL(path: String) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }
    
    private static func hasInternetAccess() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var hasInternet = false

        if let url = URL(string: "https://www.google.com") {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)

            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    hasInternet = (httpResponse.statusCode == 200)
                }

                semaphore.signal()
            }

            task.resume()
            _ = semaphore.wait(timeout: .now() + 5.0) // Adjust the timeout as needed

        }

        return hasInternet
    }
}
