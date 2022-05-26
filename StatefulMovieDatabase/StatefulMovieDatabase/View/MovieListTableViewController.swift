//
//  MovieListTableViewController.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var movies: [Movie] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkController.search(searchTerm: "") { movies in
           guard let movies = movies else {return}
            self.movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchBar.resignFirstResponder()
            }
        }
        searchBar.delegate = self
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.updateView(with: movie)
        return cell
    }
    
}

extension MovieListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchTerm = searchBar.text else {return}
        
        NetworkController.search(searchTerm: searchTerm) { movies in
           guard let movies = movies else {return}
            self.movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchBar.resignFirstResponder()
            }
        }
    }
}
