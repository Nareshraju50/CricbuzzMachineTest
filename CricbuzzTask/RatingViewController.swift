//
//  RatingViewController.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

class RatingViewController: UIViewController {

    // MARK: - Properties
       
       private var selectedRate: Int = 0
       
       private let feedbackGenerator = UISelectionFeedbackGenerator()
       
       // MARK: - User Interface
       
       private let container: UIStackView = {
           let stackView = UIStackView()
           stackView.spacing = 70
           stackView.axis = .vertical
           return stackView
       }()
       
       private let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "Rate our service"
           label.font = .systemFont(ofSize: 35, weight: .semibold)
           label.textAlignment = .center
           label.textColor = .init(named: "#9b70b7")
           return label
       }()
       
       private lazy var sendButton: UIButton = {
           let button = UIButton()
           button.backgroundColor = UIColor(named: Colors.buttonColor)
           button.setTitle("Send", for: .normal)
           button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
           button.layer.cornerRadius = 8
           button.addTarget(self, action: #selector(showAlertAction), for: .touchUpInside)
           return button
       }()
       
       private lazy var starsContainer: UIStackView = {
           let stackView = UIStackView()
           stackView.axis = .horizontal
           stackView.distribution = .fillEqually
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectRate))
           stackView.addGestureRecognizer(tapGesture)
           
           return stackView
       }()
       
       // MARK: - Lifecycle
       
       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = UIColor(named: Colors.primeColor)
           navigationController?.navigationBar.isHidden = true
           createStars()
           setupUI()
       }
       
       // MARK: - User Action
       
       @objc private func didSelectRate(gesture: UITapGestureRecognizer) {
           let location = gesture.location(in: starsContainer)
           let starWidth = starsContainer.bounds.width / CGFloat(Constants.starsCount)
           let rate = Int(location.x / starWidth) + 1
           
           if rate != self.selectedRate {
               feedbackGenerator.selectionChanged()
               self.selectedRate = rate
           }
           
           starsContainer.arrangedSubviews.forEach { subview in
               guard let starImageView = subview as? UIImageView else {
                   return
               }
               starImageView.isHighlighted = starImageView.tag <= rate
           }
       }
       
       @objc private func showAlertAction() {
           let alert = UIAlertController(title: "Info",
                                         message: "Thank you very much for your feedback! \nWe value everyone and strive to be better.",
                                         preferredStyle: .alert)
           
           let okayAction = UIAlertAction(title: "Close", style: .default) { action in
               self.navigationController?.popViewController(animated: true)
           }
           
           alert.addAction(okayAction)
           
           present(alert, animated: true)
       }
       
       // MARK: - Private methods
       
       private func createStars() {
           for index in 1...Constants.starsCount {
               let star = makeStarIcon()
               star.tag = index
               starsContainer.addArrangedSubview(star)
           }
       }
       
       private func makeStarIcon() -> UIImageView {
           let imageView = UIImageView(image: #imageLiteral(resourceName: "star_empty"), highlightedImage: #imageLiteral(resourceName: "star_filled"))
           imageView.contentMode = .scaleAspectFit
           imageView.isUserInteractionEnabled = true
           return imageView
       }
       
       private func setupUI() {
           sendButton.addPulsationAnimation()
           
           view.addSubview(container)
           container.translatesAutoresizingMaskIntoConstraints = false
           container.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.containerHorizontalInsets).isActive = true
           container.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.containerHorizontalInsets).isActive = true
           container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
           
           starsContainer.translatesAutoresizingMaskIntoConstraints = false
           starsContainer.heightAnchor.constraint(equalToConstant: Constants.starContainerHeight).isActive = true
           
           sendButton.translatesAutoresizingMaskIntoConstraints = false
           sendButton.heightAnchor.constraint(equalToConstant: Constants.sendButtonHeight).isActive = true
           
           container.addArrangedSubview(titleLabel)
           container.addArrangedSubview(starsContainer)
           container.addArrangedSubview(sendButton)
       }
       
       // MARK: - Constants {
       
       private struct Constants {
           static let starsCount: Int = 5
           
           static let sendButtonHeight: CGFloat = 50
           static let containerHorizontalInsets: CGFloat = 30
           static let starContainerHeight: CGFloat = 40
       }

}
