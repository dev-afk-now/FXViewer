//
//  CurrencyCollectionViewCell.swift
//  FXViewer
//
//  Created by Nik Dub on 10.04.2025.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell, Configurable {
    
    // MARK: - Private properties -
    
    private lazy var containerView: UIView = {
        $0.layer.cornerRadius = Constants.containerCornerRadius
        $0.clipsToBounds = true
        $0.backgroundColor = .appColor(.containerDark)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var stackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.contentMode = .scaleAspectFit
        $0.distribution = .fillProportionally
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var titleStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 2
        $0.contentMode = .scaleAspectFit
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var flagImageView: UIImageView = {
        $0.image = UIImage(named: "norway")
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var nameLabel: UILabel = {
        $0.text = "US Dollar"
        $0.textColor = .appColor(.titleLight)
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var codeLabel: UILabel = {
        $0.text = "USD"
        $0.textColor = .appColor(.subtitleDark)
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        return $0
    }(UILabel())
    
    private lazy var priceLabel: UILabel = {
        $0.text = "0.89"
        $0.textColor = .appColor(.titleLight)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstrains()
    }
    
    // MARK: - Private methods -
    
    private func setupConstrains() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        titleStackView.addArrangedSubview(nameLabel)
        titleStackView.addArrangedSubview(codeLabel)
        stackView.addArrangedSubview(flagImageView)
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.verticalInset
            ),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.verticalInset
            ),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.horizontalInset
            ),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.horizontalInset
            ),
            
            stackView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: Constants.containerInset
            ),
            stackView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -Constants.containerInset
            ),
            stackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Constants.containerInset
            ),
            stackView.trailingAnchor.constraint(
                equalTo: priceLabel.trailingAnchor
            ),
            priceLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Constants.containerInset
            ),
            
            flagImageView.widthAnchor.constraint(equalToConstant: 40),
            
//            priceLabel.heightAnchor.constraint(equalToConstant: 17),
//            priceLabel.widthAnchor.constraint(equalToConstant: 25)
        ])
        contentView.isShimmering = true
    }
    
    func configure(with model: CurrencyModel) {}
}


extension CurrencyCollectionViewCell {
    enum Constants {
        static let verticalInset: CGFloat = 2
        static let horizontalInset: CGFloat = 20
        static let containerInset: CGFloat = 16
        static let containerCornerRadius: CGFloat = 12
    }
}
