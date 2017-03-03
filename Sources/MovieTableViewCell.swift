//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Jeremiah Hawks on 3/3/17.
//  Copyright © 2017 Open Reel Software. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var moviePlotTextView: UITextView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
        
    // MARK: - Properties
    var movie: JSHMovie? {
        didSet {
            self.updateViews()
        }
    }
    
    func updateViews() {
        guard let movie = movie else { return }
        if let image = movie.movieImage {
            movieImageView.image = image
            moviePlotTextView.text = movie.plot
            movieTitleLabel.text = movie.title
            if let movieRating = movie.rating {
                movieRatingLabel.text = "\(movieRating) stars"
            }
        } else {
            moviePlotTextView.text = movie.plot
            movieTitleLabel.text = movie.title
            if let movieRating = movie.rating {
                movieRatingLabel.text = "\(movieRating) stars"
            }
        }
    }
}
