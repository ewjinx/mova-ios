//
//  RecommendationCell.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 8/5/2026.
//

import Foundation
import UIKit
import SDWebImage


class RecommendationCell: UITableViewCell {
    static let identifier = "RecommendationCell"
    
    private var heightConstraint: NSLayoutConstraint?
    
    var didSelectMovie: ((MovieDetails.FetchMovie.ViewModel.DisplayedRecommendation) -> Void)?
    
    private var recommendations: [MovieDetails.FetchMovie.ViewModel.DisplayedRecommendation] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        if heightConstraint?.constant != contentHeight {
            heightConstraint?.constant = contentHeight
        }
    }
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.bounds.size.width = targetSize.width
        self.contentView.bounds.size.width = targetSize.width
        
        self.layoutIfNeeded()
        
        collectionView.layoutIfNeeded()
        let size = collectionView.collectionViewLayout.collectionViewContentSize
        
        return CGSize(width: targetSize.width, height: size.height + 40)
    }

    
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        self.backgroundColor = .background
        
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
        let hConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1000)
        hConstraint.priority = .defaultLow
        self.heightConstraint = hConstraint

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }

    func configure(with data: [MovieDetails.FetchMovie.ViewModel.DisplayedRecommendation]) {
        self.recommendations = data
        collectionView.reloadData()
    }

}

extension RecommendationCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = recommendations[indexPath.item]
        
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16) / 2
        return CGSize(width: width, height: width * 1.5) // Standard movie poster ratio
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedMovie = recommendations[indexPath.item]
            
            didSelectMovie?(selectedMovie)
        }
}
