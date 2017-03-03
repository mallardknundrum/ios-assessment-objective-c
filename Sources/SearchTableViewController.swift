//
//  SearchTableViewController.swift
//  MovieSearch
//
//  Created by Jeremiah Hawks on 3/3/17.
//  Copyright © 2017 Open Reel Software. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UITableView!
    
    var movieSearchResultsArray: [JSHMovie] = []
    let movieController = JSHMovieController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        movieController.fetchMovies(withSearchTerm: searchBar.text) { (movieArray, error) in
            if (error != nil)  {
                print("There was a problem when clicking the search button")
                return
            } else {
                guard let unwrappedMovieArray = movieArray as? [JSHMovie] else { return }
                
                self.movieSearchResultsArray = unwrappedMovieArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSearchResultsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie = movieSearchResultsArray[indexPath.row]
        cell.movie = movie
        return cell
    }
}
