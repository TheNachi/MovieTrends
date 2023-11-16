//
//  MovieTableViewCell.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private let cellPadding: CGFloat = 16.0
    private let cellSpacing: CGFloat = 8.0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.priceLabelBackgroundColor
        label.textAlignment = .center
        return label
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        return view
    }()
    
    var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.backgroundColor = UIColor.white // Set the background color
        
        // Add corner radius and shadow
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.contentView.layer.shadowRadius = 5
        
        // Add padding
        self.contentView.layoutMargins = UIEdgeInsets(top: cellPadding, left: cellPadding, bottom: cellPadding, right: cellPadding)
        
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(movieImageView)
        
        self.movieImageView.addSubview(yearLabel)
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor, constant: cellSpacing),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor, constant: cellSpacing),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor, constant: -cellSpacing),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor, constant: cellSpacing),
            
            movieImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            yearLabel.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -10),
            yearLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 15),
            yearLabel.heightAnchor.constraint(equalToConstant: 30),
            yearLabel.widthAnchor.constraint(equalToConstant: 55),
            
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400)
        ])
    }
    
    func configure(with movie: Movie) {
        let year = movie.release_date.prefix(4)
             yearLabel.text = String(year)
         
        if let movieUrl = movie.posterPathURL() {
            preloadImage(from: movieUrl)
        }
    }
    
    private func preloadImage(from url: URL) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error preloading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.movieImageView.image = image
                }
            }
        }
        task.resume()
    }
}
