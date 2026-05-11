//
//  SectionHeaderView.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 4/5/2026.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"
    
    var sectionIndex: Int = 0
    var onSeeAllTapped: ((Int) -> Void)?
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See all", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "BackgroundColor")
        addSubview(titleLabel)
        addSubview(seeAllButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            seeAllButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        seeAllButton.addTarget(self, action: #selector(didTapSeeAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(title: String) {
        titleLabel.text = title
        titleLabel.textColor = .movaLabel
    }
    
    @objc private func didTapSeeAll() {
        onSeeAllTapped?(sectionIndex)
    }
}
