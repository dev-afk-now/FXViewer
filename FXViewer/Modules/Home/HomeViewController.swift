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
    
    private var collectionView: UICollectionView!
    private var collectionAdapter: HomeCollectionAdapter!
    private lazy var navigationBar: UIView = {
        let label = UILabel()
        label.text = "Currencies"
        $0.addSubview(label)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private let graphqlService = DIContainer.shared.graphQLService
    
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
        graphqlService.fetchCurrencies()
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
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(for: SkeletonCell.self)
        collectionAdapter = HomeCollectionAdapter(
            collectionView: collectionView
        )
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
//        view.addSubview(navigationBar)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
//            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
//            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.applyBottomGradient()
    }
    
    func showLoading() {
        collectionAdapter.applySnapshot(
            sections: [.skeleton],
            itemsBySection: [.skeleton: CurrencyModel.placeholderList]
        )
    }
    
    func updateDataSource(_ items: [CurrencyModel]) {
        collectionAdapter.applySnapshot(sections: [.main], itemsBySection: [.main: []])
    }
    
    private func handleStateUpdate(_ state: HomeViewModelState) -> () {
        print("updated value: \(state)")
        switch state {
        case .idle, .started:
            break
        case .loading:
            showLoading()
        case .updated(let elements):
            updateDataSource(elements)
        }
    }
}
