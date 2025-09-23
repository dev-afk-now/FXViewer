//
//  FavoritesViewController.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: FavoritesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var collectionView: UICollectionView!
    private var collectionAdapter: HomeCollectionAdapter!
    
    // MARK: - UI properties
    
    private lazy var emptyStateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Favorite currencies will be displayed here"
        $0.layer.cornerRadius = 10
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.isHidden = true
        $0.alpha = 0.4
        return $0
    }(UILabel())
    
    // MARK: - Init -
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupConstrains()
        initialSetup()
    }
    
    // MARK: - Private methods
    
    private func initialSetup() {
        view.backgroundColor = .appColor(.background)
        viewModel.$state
            .sink(receiveValue: handleStateUpdate)
            .store(in: &cancellables)
        configureNavgationBar()
        viewModel.start()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(for: SkeletonCell.self)
        collectionView.register(for: CurrencyCell.self)
        collectionAdapter = HomeCollectionAdapter(
            collectionView: collectionView
        ) { [weak self] in
            self?.viewModel.removeCurrency($0)
            self?.viewModel.retrieveFavorites()
        }
        collectionView.delegate = collectionAdapter
    }
    
    private func configureNavgationBar() {
        title = "Favorites"
        navigationItem.largeTitleDisplayMode = .never
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
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 32,
            leading: .zero,
            bottom: 32,
            trailing: .zero
        )
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupConstrains() {
        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateLabel.heightAnchor.constraint(equalTo: emptyStateLabel.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.applyBottomGradient()
    }
    
    private func updateDataSource(_ items: [CurrencyModel]) {
        collectionAdapter.applySnapshot(
            sections: [.main],
            itemsBySection: [.main: items]
        )
    }
    
    private func setEmptyViewHidden(_ value: Bool) {
        emptyStateLabel.isHidden = value
    }
}

// MARK: - Extensions

extension FavoritesViewController {
    func handleStateUpdate(_ state: FavoritesViewModelState) {
        setEmptyViewHidden(state != .idle)
        switch state {
        case .idle:
            updateDataSource([])
        case .updated(let array):
            updateDataSource(array)
        }
    }
}
