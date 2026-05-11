import UIKit
import SDWebImage

class TableHeaderView: UIView {
    
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let movieSummaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    private var infoStack = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        addSubview(imageView)
        addSubview(mainStackView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        infoStack = createInfoRowStack()
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(infoStack)
        mainStackView.addArrangedSubview(createButtonsStack())
        mainStackView.addArrangedSubview(movieSummaryLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func createInfoRowStack() -> UIStackView {
        let starIcon = UIImageView(image: UIImage(systemName: "star.fill"))
        starIcon.tintColor = .systemRed
        starIcon.translatesAutoresizingMaskIntoConstraints = false
        starIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        starIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [
            starIcon, ratingLabel, yearLabel,
            createBadgeView(with: "13+"),
            createBadgeView(with: "United States"),
            spacer
        ])
        
        stack.spacing = 12
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        
        return stack
    }
    
    private func createButtonsStack() -> UIStackView {
        let playButton = createHeroButton(title: "Play", icon: "play.fill", color: .systemRed)
        let downloadButton = createHeroButton(title: "Download", icon: "arrow.down.to.line", color: .clear, isOutline: true)
        
        let stack = UIStackView(arrangedSubviews: [playButton, downloadButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }

    private func createHeroButton(title: String, icon: String, color: UIColor, isOutline: Bool = false) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: icon)
        config.imagePadding = 8
        config.cornerStyle = .capsule
        config.baseBackgroundColor = color
        config.baseForegroundColor = isOutline ? .systemRed : .white
        
        let button = UIButton(configuration: config)
        
        if isOutline {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemRed.cgColor
            button.layer.cornerRadius = 22
        }
        return button
    }

    private func createBadgeView(with text: String) -> UIView {
        let container = UIView()
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemRed.cgColor
        container.layer.cornerRadius = 4
        
        let label = UILabel()
        label.text = text
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6)
        ])
        return container
    }
    
    
    func configure(with movie: MovieDetails.FetchMovie.ViewModel.DisplayedMovie) {
        
        self.backgroundColor = .background
        
        titleLabel.text = movie.title
        movieSummaryLabel.text = movie.description
        
        ratingLabel.text = "\(movie.rating)"
        yearLabel.text = "\(movie.year)"
        
        imageView.sd_setImage(
            with: movie.backdropUrl,
            placeholderImage: UIImage(systemName: "photo")
        )
    }
}
