import UIKit
import Foundation




class ProfileTableViewCell: UITableViewCell {
    static let identifier = "ProfileTableViewCell"

    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .movaLabel
        return iv
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .movaLabel
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    let chevronImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = .movaLabel
        return iv
    }()

    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .movaLabel
        label.textAlignment = .right
        return label
    }()

    let toggleSwitch: UISwitch = {
        let control = UISwitch()
        return control
    }()

    private let spacerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        backgroundColor = UIColor(named: "BackgroundColor")
        contentView.backgroundColor = UIColor(named: "BackgroundColor")

        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        detailLabel.setContentHuggingPriority(.required, for: .horizontal)
        toggleSwitch.setContentHuggingPriority(.required, for: .horizontal)
        chevronImageView.setContentHuggingPriority(.required, for: .horizontal)

        let stack = UIStackView(arrangedSubviews: [
            iconImageView,
            titleLabel,
            spacerView,
            detailLabel,
            toggleSwitch,
            chevronImageView
        ])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
