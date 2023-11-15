//
//  MovieDetailsViewController.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let viewModel: MovieDetailsViewModel

        init(viewModel: MovieDetailsViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViews()
        self.updateUI(with: viewModel.getMovieDetails())
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBackgroundColor
        
    }
    
    private func updateUI(with movieDetails: MovieDetails?) {
        guard let movieDetails = movieDetails else {
            // Handle error or display an alert
            return
        }

        // Update UI elements with movieDetails data
        priceLabel.text = movieDetails.original_title
        descriptionLabel.text = movieDetails.overview

        if let imageUrl = MovieService.getImageURL(path: movieDetails.poster_path) {
            productImageView.load(url: imageUrl)
        }
    }
    
    
    func setupViews() {
        edgesForExtendedLayout = []
        self.view.addSubview(productImageView)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(priceLabel)
        
        self.productImageView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 300),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            productImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            
        ])
    }
}
