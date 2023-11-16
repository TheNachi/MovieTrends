//
//  MovieDetailsViewController.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    
    var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    var movieYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .justified
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
        self.setupUI()
        self.updateUI(with: viewModel.getMovieDetails())
        self.navigationController?.view.backgroundColor = UIColor.white
    }
    
    private func updateUI(with movieDetails: MovieDetails?) {
        guard let movieDetails = movieDetails else {
            return
        }
        
        let year = movieDetails.release_date.prefix(4)
        
        movieTitleLabel.text = movieDetails.original_title
        movieYearLabel.text = String(year)
        movieOverviewLabel.text = movieDetails.overview
        
        if let imageUrl = MovieService.getImageURL(path: movieDetails.poster_path) {
            movieImageView.load(url: imageUrl)
        }
    }
    
    
    func setupUI() {
        edgesForExtendedLayout = []

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)

        scrollView.addSubview(movieImageView)
        scrollView.addSubview(movieOverviewLabel)
        scrollView.addSubview(movieTitleLabel)
        scrollView.addSubview(movieYearLabel)

        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        self.movieImageView.translatesAutoresizingMaskIntoConstraints = false
        self.movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.movieYearLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            movieImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 300),
            movieImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            movieImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            movieImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),

            movieTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            movieTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20),

            movieYearLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            movieYearLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            movieYearLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            movieYearLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 5),

            movieOverviewLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            movieOverviewLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            movieOverviewLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            movieOverviewLabel.topAnchor.constraint(equalTo: movieYearLabel.bottomAnchor, constant: 20),
            movieOverviewLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
        ])
    }

}
