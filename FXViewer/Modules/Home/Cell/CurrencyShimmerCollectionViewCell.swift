//
//  CurrencyShimmerCollectionViewCell.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//
import UIKit

class CurrencyShimmerCollectionViewCell: UICollectionViewCell, Configurable {
    
    // MARK: - Private properties -
    
    private lazy var containerView: UIView = {
        $0.layer.cornerRadius = Constants.containerCornerRadius
        $0.clipsToBounds = true
        $0.backgroundColor = .appColor(.containerDark)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var flagPlaceholderView: UIView = {
        $0.layer.cornerRadius = 6
        $0.backgroundColor = .lightGray
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var namePlaceholderView: UIView = {
        $0.layer.cornerRadius = 6
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var codePlaceholderView: UIView = {
        $0.layer.cornerRadius = 6
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var pricePlaceholderView: UIView = {
        $0.layer.cornerRadius = 6
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
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
        containerView.addSubview(namePlaceholderView)
        containerView.addSubview(codePlaceholderView)
        containerView.addSubview(flagPlaceholderView)
        containerView.addSubview(pricePlaceholderView)
        
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
            
            flagPlaceholderView.centerYAnchor.constraint(
                equalTo: containerView.centerYAnchor
            ),
            flagPlaceholderView.widthAnchor.constraint(equalToConstant: 40),
            flagPlaceholderView.heightAnchor.constraint(equalToConstant: 32),
            flagPlaceholderView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Constants.containerInset
            ),
            flagPlaceholderView.trailingAnchor.constraint(
                equalTo: namePlaceholderView.leadingAnchor,
                constant: -12
            ),
//            priceLabel.trailingAnchor.constraint(
//                equalTo: containerView.trailingAnchor,
//                constant: -Constants.containerInset
//            ),
            namePlaceholderView.widthAnchor.constraint(equalToConstant: 125),
            namePlaceholderView.heightAnchor.constraint(equalToConstant: 13),
            namePlaceholderView.topAnchor.constraint(
                equalTo: flagPlaceholderView.topAnchor
            ),
            codePlaceholderView.widthAnchor.constraint(equalToConstant: 45),
            codePlaceholderView.topAnchor.constraint(
                equalTo: namePlaceholderView.bottomAnchor,
                constant: 2
            ),
            codePlaceholderView.heightAnchor.constraint(equalToConstant: 13),
            codePlaceholderView.leadingAnchor.constraint(
                equalTo: namePlaceholderView.leadingAnchor
            ),
//            codePlaceholderView.bottomAnchor.constraint(
//                equalTo: flagPlaceholderView.bottomAnchor,
//                constant: 5
//            ),
            
            pricePlaceholderView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Constants.containerInset
            ),
            pricePlaceholderView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            pricePlaceholderView.widthAnchor.constraint(equalToConstant: 45),
            pricePlaceholderView.heightAnchor.constraint(equalToConstant: 13)
            
//            flagImageView.widthAnchor.constraint(equalToConstant: 40),
//            codeLabel.widthAnchor.constraint(equalToConstant: 20),
//            priceLabel.widthAnchor.constraint(equalToConstant: 20),
//            nameLabel.widthAnchor.constraint(equalToConstant: 20),
            
//            priceLabel.heightAnchor.constraint(equalToConstant: 17),
//            priceLabel.widthAnchor.constraint(equalToConstant: 25)
        ])
        contentView.isShimmering = true
    }
    
    func configure(with model: CurrencyModel) {}
}


extension CurrencyShimmerCollectionViewCell {
    enum Constants {
        static let verticalInset: CGFloat = 2
        static let horizontalInset: CGFloat = 20
        static let containerInset: CGFloat = 16
        static let containerCornerRadius: CGFloat = 12
    }
}
