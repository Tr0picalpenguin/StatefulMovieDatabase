//
//  NetworkController.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import Foundation
import UIKit.UIImage

class NetworkController {
    static let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")
    
    
    static func fetchMovieDictionary(with searchTerm: String, completion: @escaping(Result<MovieDictionary, ResultError>) -> Void) {
        guard let baseURL = baseURL else {return}
        completion(.failure(.invalidURL(baseURL)))
        
        var urlComponents = URLComponents.init(url: baseURL, resolvingAgainstBaseURL: true)
        let apiKeyQuery = URLQueryItem(name: "api_key", value: "820708be1a1f7f76083138998b15b1d5")
        let searchQuery = URLQueryItem(name: "query", value: searchTerm)
        urlComponents?.queryItems = [apiKeyQuery, searchQuery]
        
        guard let finalUrl = urlComponents?.url else {return}
        completion(.failure(.invalidURL(finalUrl)))
        
        URLSession.shared.dataTask(with: finalUrl) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                print("Encountered Error: \(error.localizedDescription)")
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let movieDictionary = try JSONDecoder().decode(MovieDictionary.self, from: data)
                completion(.success(movieDictionary))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchPosterPath(with posterPathString: String, completion: @escaping(Result<UIImage, ResultError>) -> Void) {
        guard let baseImageURL = URL(string: "https://image.tmdb.org/t/p/w500") else {return}
        let finalURL = baseImageURL.appendingPathComponent(posterPathString)
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Encountered Error: \(error.localizedDescription)")
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            guard let posterImage = UIImage(data: data) else {
                completion(.failure(.unableToDecode))
                return
            }
            completion(.success(posterImage))
        }.resume()
    }
} // End of class

    
    
//    static func fetchMovieWith(searchTerm: String, completion: @escaping ([Movie]?) -> Void) {
//
//        guard let url = baseURL else { completion(nil); return }
//
//        let apiKey = URLQueryItem(name: "api_key", value: "1622677c9c625ef4e4e27c015befec5f")
//        let searchKey = URLQueryItem(name: "query", value: searchTerm)
//
//        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
//        urlComponents?.queryItems = [apiKey, searchKey]
//
//        guard let finalURL = urlComponents?.url else { completion(nil); return }
//
//        URLSession.shared.dataTask(with: finalURL) { data, _, error in
//
//            if let error = error {
//                print(error.localizedDescription)
//                completion([])
//                return
//            }
//
//            guard let data = data,
//                  let responseDataString = String(data: data, encoding: .utf8) else { print("No data return from network request"); completion([]); return }
//            do {
//                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
//
//                guard let movieArray = jsonDictionary?["results"] as? [[String:Any]] else { print("Unable to serialize JSON. Response: \(responseDataString)"); completion([]); return }
//
//                let movies = movieArray.compactMap({ Movie(dictionary: $0) })
//                completion(movies)
//            } catch let error {
//                print(error)
//            }
//        }.resume()
//    }
//
//    static func image(forURL url: String, completion: @escaping (UIImage?) -> Void) {
//
//        guard let imageURL = URL(string: url) else {
//            fatalError("Image URL optional is nil")
//        }
//
//        URLSession.shared.dataTask(with: imageURL) { data, _, error in
//            guard let data = data else {
//                return
//            }
//            let image = UIImage(data: data)
//            completion(image)
//        }.resume()
//    }
