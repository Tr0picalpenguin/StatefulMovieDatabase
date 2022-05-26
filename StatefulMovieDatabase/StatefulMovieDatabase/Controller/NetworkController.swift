//
//  NetworkController.swift
//  StatefulMovieDatabase
//
//  Created by Scott Cox on 5/26/22.
//

import Foundation

class NetworkController {
    
    // MARK: - Properties
    static private let baseURLString = "https://api.themoviedb.org/3"
    
    // MARK: - CRUD
    static func search(searchTerm: String, completion: @escaping([Movie]?) -> Void) {
        // Construct the URL
        guard let baseURL = URL(string: baseURLString) else {completion(nil); return}
        let searchMovieURL = baseURL.appendingPathComponent("search/movie")
        
        var urlComponents = URLComponents(url: searchMovieURL, resolvingAgainstBaseURL: true)
        
        // create query items
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: "820708be1a1f7f76083138998b15b1d5")
        
        let searchQueryItem = URLQueryItem(name: "query", value: searchTerm)
        
        urlComponents?.queryItems = [apiKeyQueryItem,searchQueryItem]
        
        guard let finalURL = urlComponents?.url else {completion(nil); return}
        
        // Perform the dataTask
        URLSession.shared.dataTask(with: finalURL) { movieData, _, error in
            if let error = error {
                print("Danger Will Robinson! Encountered an Error.", error.localizedDescription)
                completion(nil)
                return
            }
            guard let movieData = movieData else {
                completion(nil)
                return
            }
            do {
                guard let topLevelDictionary = try JSONSerialization.jsonObject(with: movieData, options: .fragmentsAllowed) as? [String:Any],
                      let resultsArray = topLevelDictionary["results"] as? [[String:Any]] else {completion(nil); return}
                
                // create a temprorary array to store movies in
//                var tempArray: [Movie] = []
//                for movieDictionary in resultsArray {
//                    guard let movie = Movie(movieDictionary: movieDictionary) else {completion(nil); return}
//                    tempArray.append(movie)
//                }
                // This next line is doing the exact same thing as the commented out code above.
                let movies = resultsArray.compactMap({Movie(movieDictionary: $0)})
                completion(movies)
            } catch {
                print("Oh no! Get some popcorn because we got an Error decoding the movie.", error.localizedDescription)
                
            }
        }.resume()
    }
    
    func fetchImage() {
        
    }
    
} // End of class
