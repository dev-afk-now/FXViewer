//
//  HomeViewController.swift
//  FXViewer
//
//  Created by Nik Dub on 31.03.2025.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Private properties -
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var collectionView: UICollectionView!
    private var collectionAdapter: HomeCollectionAdapter!
    private lazy var navigationBar: PullHeaderView = {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Pull to update"
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .gray
        $0.textAlignment = .center
        $0.onAction = { [unowned self] in
            self.viewModel.start()
        }
        $0.alpha = .zero
        return $0
    }(PullHeaderView())
    
    private lazy var emptyImageView: UIImageView = {
        $0.image = UIImage(named: "fxviewerlogo")!
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.alpha = 0.4
        return $0
    }(UIImageView())
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init -
    
    init(viewModel: HomeViewModel) {
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
    
    private func initialSetup() {
        view.backgroundColor = .appColor(.background)
        title = "Currencies"
        viewModel.$state
            .sink(receiveValue: handleStateUpdate)
            .store(in: &cancellables)
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
            collectionView: collectionView,
            pullDelegate: navigationBar
        )
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
    
    // MARK: - Private methods -
    
    private func setupConstrains() {
        collectionView.addSubview(navigationBar)
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
            
            navigationBar.topAnchor.constraint(equalTo: collectionView.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 25),
//            navigationBar.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
//            navigationBar.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
            navigationBar.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
//        view.sendSubviewToBack(emptyImageView)
        view.applyBottomGradient()
    }
    
    func showLoading() {
        collectionAdapter.applySnapshot(
            sections: [.skeleton],
            itemsBySection: [.skeleton: CurrencyModel.placeholderList]
        )
    }
    
    func updateDataSource(_ items: [CurrencyModel]) {
        collectionView.setContentOffset(.zero, animated: false)
        collectionAdapter.applySnapshot(sections: [.main], itemsBySection: [.main: items])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned self] in
            collectionView.setContentOffset(.zero, animated: false)
        }
    }
    
    private func handleStateUpdate(_ state: HomeViewModelState) -> () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.emptyImageView.isHidden = state != .idle
        }
        DispatchQueue.main.async { [unowned self] in
            switch state {
            case .idle:
                updateDataSource([])
            case .loading:
                showLoading()
            case .updated(let elements):
                updateDataSource(elements)
            }
        }
    }
}
