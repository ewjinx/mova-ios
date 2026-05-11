import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let ratingBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.89, green: 0.11, blue: 0.14, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(named: "BackgroundColor")

        contentView.addSubview(posterImageView)
        contentView.addSubview(ratingBadge)
        ratingBadge.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ratingBadge.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 8),
            ratingBadge.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 8),
            ratingBadge.widthAnchor.constraint(equalToConstant: 28),
            ratingBadge.heightAnchor.constraint(equalToConstant: 18),
            
            ratingLabel.centerXAnchor.constraint(equalTo: ratingBadge.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingBadge.centerYAnchor)
        ])
    }
    
    // called by the vip when viewmodel is received
    func configure(with movie: MovieCellRepresentable) {
        ratingLabel.text = movie.rating
        posterImageView.sd_setImage(with: movie.imageUrl)
    }
}
