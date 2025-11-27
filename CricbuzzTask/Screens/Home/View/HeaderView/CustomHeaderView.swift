//
//  CustomHeaderView.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

class CustomHeaderView: UIView {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel! {
        didSet {
            movieTitle.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var genre: UILabel!
    
}
