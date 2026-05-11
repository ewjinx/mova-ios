import UIKit
import Foundation
import SDWebImage

class HeroCollectionViewCell: UICollectionViewCell {
    static let identifier = "HeroCollectionViewCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    
    
    private let gradientLayer = CAGradientLayer()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        return stack
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(named: "BackgroundColor")

        contentView.addSubview(imageView)
        contentView.addSubview(infoStack)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        imageView.layer.addSublayer(gradientLayer)
        
        let playButton = createHeroButton(title: "Play", icon: "play.fill", color: .systemRed)
        let myListButton = createHeroButton(title: "My List", icon: "plus", color: .clear, isOutline: true)
        
        buttonStack.addArrangedSubview(playButton)
        buttonStack.addArrangedSubview(myListButton)
        
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(genresLabel)
        infoStack.addArrangedSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            buttonStack.leadingAnchor.constraint(equalTo: infoStack.leadingAnchor),
            buttonStack.trailingAnchor.constraint(lessThanOrEqualTo: infoStack.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 45),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: infoStack.widthAnchor)
        ])
    }
    
    func configure(with viewModel: Home.FetchMovies.ViewModel.DisplayedMovie) {
        titleLabel.text = viewModel.title
        imageView.sd_setImage(with: viewModel.imageUrl)
        genresLabel.text = viewModel.genres
    }
    
    private func createHeroButton(title: String, icon: String, color: UIColor, isOutline: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: icon)
        config.imagePadding = 8
        config.baseBackgroundColor = color
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        
        if isOutline {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 22.5 
        }
        
        button.configuration = config
        return button
    }
}
