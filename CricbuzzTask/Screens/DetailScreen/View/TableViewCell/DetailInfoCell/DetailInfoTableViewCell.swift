//
//  MoviesViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

class DetailInfoTableViewCell: UITableViewCell {
    
    static let identifier  = "DetailInfoTableViewCell"

    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var RunTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ movieDetail: MovieDetails) {
        self.movieOverview.text = "\(movieDetail.Plot ?? CommonConstant.emptyString)"
        self.RunTime.text = "RunTime:\(movieDetail.Runtime ?? CommonConstant.emptyString)"
    }
    
}
