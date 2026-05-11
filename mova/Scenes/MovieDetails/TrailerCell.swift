//
//  TrailerCell.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 8/5/2026.
//

import Foundation
import UIKit
import SDWebImage



class TrailerCell: UITableViewCell {
    static let identifier = "TrailerCell"

    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()

    private let playIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "play.circle.fill"))
        iv.tintColor = .white
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        
        self.backgroundColor = .background
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.addSubview(playIcon)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, durationLabel])
        stack.axis = .vertical
        stack.spacing = 4
        contentView.addSubview(stack)

        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 120),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),

            playIcon.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            playIcon.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 24),
            playIcon.heightAnchor.constraint(equalToConstant: 24),

            stack.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor)
        ])
    }

    func configure(with trailer: MovieDetails.FetchMovie.ViewModel.DisplayedTrailer) {
        titleLabel.text = trailer.name
        durationLabel.text = trailer.duration
        thumbnailImageView.sd_setImage(with: trailer.thumbnailUrl)
    }
}
