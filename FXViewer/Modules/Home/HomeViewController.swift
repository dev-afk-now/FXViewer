//
//  HomeViewController.swift
//  FXViewer
//
//  Created by Nik Dub on 31.03.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Private properties -
    
    private var collectionView: UICollectionView!
    private lazy var navigationBar: UIView = {
        $0.backgroundColor = .darkGray
        let label = UILabel()
        label.text = "Currencies"
        $0.addSubview(label)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    lazy var blurEffect = UIBlurEffect(style: .dark) // можно .light, .dark, .systemChromeMaterial и др.
    lazy var blurView = UIVisualEffectView(effect: blurEffect)
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupConstrains()
        view.backgroundColor = .appColor(.background)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )
//        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.registerNib(for: CurrencyCollectionViewCell.self)
        updateLayout()
        // растягиваем на всю вью
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        navigationBar.addSubview(blurView)
//        
//
//        NSLayoutConstraint.activate([
//            blurView.topAnchor.constraint(equalTo: navigationBar.topAnchor),
//            blurView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
//            blurView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
//            blurView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
//        ])
    }
    
    private func updateLayout() {
//        collectionView.collectionViewLayout.invalidateLayout()
//        collectionView.collectionViewLayout =
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(68)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
//        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(
            top: 32,
            leading: .zero,
            bottom: 32,
            trailing: .zero
        )
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Private methods -
    
    private func setupConstrains() {
        view.addSubview(navigationBar)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


// MARK: - Extensions -

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return collectionView.deque(
            type: CurrencyCollectionViewCell.self,
            indexPath: indexPath
        )
    }
}
