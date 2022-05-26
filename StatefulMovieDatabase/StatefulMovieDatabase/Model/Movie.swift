//
//  Movie.swift
//  StatefulMovieDatabase
//
//  Created by Scott Cox on 5/26/22.
//

import Foundation

class Movie {
    enum Keys: String {
        case kTitle = "title"
        case kOverview = "overview"
        case kPosterPath = "poster_path"
    }
    
    let title: String
    let overview: String
    let posterPath: String
    
    init(title: String, overview: String, posterPath: String) {
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
    }
} // End of Class

extension Movie {
    convenience init?(movieDictionary: [String:Any]) {
        guard let title = movieDictionary[Keys.kTitle.rawValue] as? String,
              let overview = movieDictionary[Keys.kOverview.rawValue] as? String,
              let posterPath = movieDictionary[Keys.kPosterPath.rawValue] as? String else {return nil}
        
        self.init(title: title, overview: overview, posterPath: posterPath)
    }
}

