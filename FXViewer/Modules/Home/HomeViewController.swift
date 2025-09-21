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
    private lazy var navigationBar: UIView = {
        let label = UILabel()
        label.text = "Currencies"
        $0.addSubview(label)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var emptyImageView: UIImageView = {
        $0.image = UIImage(named: "fxviewerlogo")!
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
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
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(for: SkeletonCell.self)
        collectionView.register(for: CurrencyCell.self)
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
        view.addSubview(emptyImageView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
//            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
//            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 150),
            emptyImageView.heightAnchor.constraint(equalTo: emptyImageView.widthAnchor),
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
        collectionAdapter.applySnapshot(sections: [.main], itemsBySection: [.main: items])
//        UIView.animate(withDuration: 0.3) { [unowned self] in
//            self.emptyImageView.alpha = items.isEmpty ? 0 : 1
//        }
    }
    
    private func handleStateUpdate(_ state: HomeViewModelState) -> () {
        print("updated value: \(state)")
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
