//
//  MoviesViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//



import UIKit


class RatingView: UIView {
    private let starImageViews: [UIImageView] = {
        var imageViews = [UIImageView]()
        for _ in 0..<10 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: ImageConstats.emptyStar)
            imageViews.append(imageView)
        }
        return imageViews
    }()
    
    var rating: Int = 0 {
        didSet {
            updateRating()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        for (index, starImageView) in starImageViews.enumerated() {
            addSubview(starImageView)
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 20),
                starImageView.heightAnchor.constraint(equalToConstant: 20),
                starImageView.topAnchor.constraint(equalTo: topAnchor),
                starImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(index * 30))
            ])
        }
    }
    
    private func updateRating() {
        for (index, starImageView) in starImageViews.enumerated() {
            let imageName = index < rating ? ImageConstats.filledStar : ImageConstats.emptyStar
            starImageView.image = UIImage(named: imageName)
        }
    }
}


   
    

