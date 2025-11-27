//
//  MoviesViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

class RatingViewTableViewCell: UITableViewCell {
    
    static let identifier = "RatingViewTableViewCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = DetailView.imdbRating
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
   
    let ratingView: RatingView = {
        let rating = RatingView()
        
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ rating: Double) {
        ratingView.rating = Int(rating)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(ratingView)
        
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(ConstraintConstants.padding)),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(ConstraintConstants.padding)),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }
}
