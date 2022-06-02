//
//  Movie.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import Foundation

struct MovieDictionary: Decodable {
    let page: Int
    let results: [ResultsDictionary]
}

struct ResultsDictionary: Decodable {
    private enum CodingKeys: String, CodingKey {
        case adult
        case title
        case overview
        case posterPath = "poster_path"
        case rating = "vote_average"
    }
    let adult: Bool
    let title: String
    let overview: String
    let posterPath: String?
    let rating: Double
}



//class Movie {
//    enum Keys: String {
//        case title = "original_title"
//        case rating = "vote_average"
//        case overview = "overview"
//        case poster = "poster_path"
//    }
//
//    var title: String
//    var rating: Double
//    var overview: String
//    private var posterPath: String
//    var imageURL: String {
//        return "https://image.tmdb.org/t/p/w500/\(posterPath)"
//    }
//
//    init?(dictionary: [String:Any]) {
//
//        guard let title = dictionary[Keys.title.rawValue] as? String,
//              let rating = dictionary[Keys.rating.rawValue] as? Double,
//              let overview = dictionary[Keys.overview.rawValue] as? String,
//              let imageEndpoint = dictionary[Keys.poster.rawValue] as? String else { return nil }
//
//        self.title = title
//        self.rating = rating
//        self.overview = overview
//        self.posterPath = imageEndpoint
//    }
//}
