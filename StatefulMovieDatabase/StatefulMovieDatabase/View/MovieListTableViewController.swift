//
//  MovieListTableViewController.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    var movies: [ResultsDictionary] = []
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        cell.setConfiguration(with: movie)
        return cell
    }
    
} // End of class

extension MovieListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text else {
            print("No text entered.")
            return
        }
        
      
        NetworkController.fetchMovieDictionary(with: searchTerm) { result in
            switch result {
            case.success(let movieDict):
                self.movies = movieDict.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchBar.resignFirstResponder()
                }
            case.failure(let error):
                print("There was an error!", error.errorDescription!)
        }
          
            
            

            
        }
        
    }
    
}
