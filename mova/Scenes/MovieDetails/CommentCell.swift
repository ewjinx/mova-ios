import UIKit
import Foundation
import SDWebImage



class CommentCell: UITableViewCell {
    static let identifier = "CommentCell"

    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private let heartIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart.fill"))
        iv.tintColor = .systemRed
        return iv
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        
        self.backgroundColor = .background
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, commentLabel])
        textStack.axis = .vertical
        textStack.spacing = 8

        let bottomStack = UIStackView(arrangedSubviews: [heartIcon, likesLabel, timeLabel, UIView()])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 8
        bottomStack.alignment = .center

        [userImageView, textStack, bottomStack].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            userImageView.heightAnchor.constraint(equalToConstant: 40),

            textStack.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12),
            textStack.topAnchor.constraint(equalTo: userImageView.topAnchor),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            heartIcon.widthAnchor.constraint(equalToConstant: 14),
            heartIcon.heightAnchor.constraint(equalToConstant: 14),

            bottomStack.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 12),
            bottomStack.leadingAnchor.constraint(equalTo: textStack.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: textStack.trailingAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with comment: MovieDetails.FetchComments.ViewModel.DisplayedComment) {
        nameLabel.text = comment.userName
        commentLabel.text = comment.text
        timeLabel.text = comment.date
        likesLabel.text = "\(comment.likes)"
        userImageView.image = UIImage(named: comment.userProfileUrl ?? "pfp1")
    }
}
