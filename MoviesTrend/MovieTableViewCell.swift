//
//  MovieTableViewCell.swift
//  MoviesTrend
//
//  Created by Munachimso Ugorji on 11/15/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private var labelHeightContraint: NSLayoutConstraint?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
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
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //    var productDescriptionLabel: UILabel = {
    //        let label = UILabel()
    //        label.numberOfLines = 0
    //        label.font = UIFont.systemFont(ofSize: 18)
    //        label.textColor = UIColor.black
    //        label.backgroundColor = UIColor.navigationBackgroundColor
    //        label.textAlignment = .center
    //        return label
    //    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        labelHeightContraint?.constant = 20
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addShadow()
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(productImageView)
        //        stackView.addArrangedSubview(productDescriptionLabel)
        
        self.productImageView.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            productImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            priceLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -10),
            priceLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 15),
            priceLabel.heightAnchor.constraint(equalToConstant: 30),
            priceLabel.widthAnchor.constraint(equalToConstant: 55),

            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),
        ])
        
        //        productDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        //        labelHeightContraint?.isActive = true
    }
    
    func configure(with movie: Movie) {
        //        print(movie.id, "the id")
        priceLabel.text = movie.release_date
        if let movieUrl = movie.posterPathURL() {
            preloadImage(from: movieUrl)
        }
        //        productDescriptionLabel.text = movie.overview
        //        DispatchQueue.main.async {
        //            self.labelHeightContraint?.constant = self.productDescriptionLabel.estimatedHeight
        //        }
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
                    self.productImageView.image = image
                }
            }
        }
        task.resume()
    }
    
}

