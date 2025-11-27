//
//  MoviesViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

class RatingInfoTableViewCell: UITableViewCell {
    
    static let identifier = "RatingInforTableViewCell"
    
    @IBOutlet weak var ratingSource1: UILabel!
    
    @IBOutlet weak var ratingView1: RatingView!
    
    
    @IBOutlet weak var ratingSource2: UILabel!
    
    @IBOutlet weak var ratinglabel2: UILabel!
    
    @IBOutlet weak var ratingSource3: UILabel!
    
    @IBOutlet weak var ratingLabel3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ movieDetail: MovieDetails) {
        let ratings = movieDetail.Ratings

        if let firstRating = ratings?.first {
            let rating = Double(firstRating.Value?.components(separatedBy: "/").first ?? "") ?? 0.0
            ratingView1.rating = Int(rating)
            ratingSource1.text = firstRating.Source
        }

        if ratings?.count ?? 0 > 1 {
            if let secondRating = ratings?[1] {
                ratinglabel2.text = secondRating.Value?.replacingOccurrences(of: "%", with: "") ?? ""
                ratingSource2.text = secondRating.Source
            }
        }

        if ratings?.count ?? 0 > 2 {
            if let thirdRating = ratings?[2] {
                ratingLabel3.text = thirdRating.Value?.components(separatedBy: "/").first ?? ""
                ratingSource3.text = thirdRating.Source
            }
        }

    }
}
