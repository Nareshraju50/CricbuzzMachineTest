//
//  AllMoviesTableViewCell.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

class AllMoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView! {
        didSet {
            posterImage.layer.cornerRadius = 10.0
            posterImage.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    static let identifier = "AllMoviesTableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(movieDetail: MovieDetails) {
        self.movieTitle.text = movieDetail.Title
        guard let urlStr = URL(string: movieDetail.Poster ?? CommonConstant.emptyString) else { return }
        self.posterImage.load(url: urlStr)
        self.languageLabel.text = "Language: \(movieDetail.Language ?? CommonConstant.emptyString)"
        self.yearLabel.text = "Year: \(movieDetail.Year)"
    }
    
}

