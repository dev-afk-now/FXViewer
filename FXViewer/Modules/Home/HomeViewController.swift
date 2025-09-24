//
//  HomeViewController.swift
//  FXViewer
//
//  Created by Nik Dub on 31.03.2025.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var collectionView: UICollectionView!
    private var collectionAdapter: HomeCollectionAdapter!
    private var isInError = false
    
    // MARK: - UI properties
    
    private lazy var pullToRefreshView: PullHeaderView = {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Pull to update"
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .gray
        $0.textAlignment = .center
        $0.onAction = { [unowned self] in
            self.viewModel.refresh()
        }
        $0.alpha = .zero
        return $0
    }(PullHeaderView())
    
    private lazy var emptyImageView: UIImageView = {
        $0.image = .appImage(.logo)
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.alpha = 0.4
        return $0
    }(UIImageView())
    
    private var leftBarLabel: UIBarButtonItem {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "icloud.slash"),
            style: .plain,
            target: self,
            action: nil
        )
        item.tintColor = .gray
        return item
    }
    
    // MARK: - Init
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupConstrains()
        initialSetup()
    }
    
    // MARK: - Private methods
    
    private func initialSetup() {
        view.backgroundColor = .appColor(.background)
        configureNavgationBar()
        viewModel.$state
            .sink(receiveValue: handleStateUpdate)
            .store(in: &cancellables)
        viewModel.start()
    }
    
    private func configureNavgationBar() {
        title = "Currencies"
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoritesTapped)
        )
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.largeTitleDisplayMode = .automatic
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
            collectionView: collectionView,
            pullDelegate: pullToRefreshView
        ) { [weak self] in
            self?.viewModel.switchCurrencyAsFavorite($0)
        }
        collectionView.delegate = collectionAdapter
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
        collectionView.addSubview(pullToRefreshView)
        view.addSubview(collectionView)
        view.addSubview(emptyImageView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyImageView.heightAnchor.constraint(equalTo: emptyImageView.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pullToRefreshView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            pullToRefreshView.heightAnchor.constraint(equalToConstant: 25),
            pullToRefreshView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
        view.applyBottomGradient()
    }
    
    private func showLoading() {
        collectionAdapter.applySnapshot(
            sections: [.skeleton],
            itemsBySection: [.skeleton: CurrencyModel.placeholderList]
        )
    }
    
    private func updateDataSource(_ items: [CurrencyModel]) {
        collectionAdapter.applySnapshot(
            sections: [.main],
            itemsBySection: [.main: items]
        )
    }
    
    private func showErrorAlert(with text: String) {
        let alert = UIAlertController(
            title: "Ooops",
            message: text,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Ok",
                style: .default,
                handler: nil
            )
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setOfflineViewState(
        _ value: Bool,
        timestamp: String?
    ) {
        navigationItem.leftBarButtonItem = value ? leftBarLabel : nil
        guard let timestamp else {
            pullToRefreshView.text = "Pull to refresh"
            return
        }
        pullToRefreshView.text = value
        ? "Last update:" + " " + timestamp
        : "Pull to refresh"
    }
    
    private func showEmptyState(_ value: Bool) {
        emptyImageView.isHidden = !value
    }
    
    
    
    // MARK: - Actions
    
    @objc private func favoritesTapped() {
        viewModel.openFavorites()
    }
}

// MARK: - Private extensions

extension HomeViewController {
    private func handleStateUpdate(_ state: HomeViewModelState) -> () {
        DispatchQueue.main.async { [unowned self] in
            showEmptyState(false)
            switch state {
            case .idle:
                showEmptyState(true)
            case .loading:
                showLoading()
            case .updated(let elements):
                updateDataSource(elements)
                setOfflineViewState(
                    false,
                    timestamp: nil
                )
                showEmptyState(elements.isEmpty)
            case .error(let message):
                showEmptyState(true)
                showErrorAlert(with: message)
                setOfflineViewState(
                    true,
                    timestamp: nil
                )
                updateDataSource([])
            case .offline(let list):
                showEmptyState(list.isEmpty)
                setOfflineViewState(
                    true,
                    timestamp: list.first?.date
                )
                updateDataSource(list)
            }
        }
    }
}
