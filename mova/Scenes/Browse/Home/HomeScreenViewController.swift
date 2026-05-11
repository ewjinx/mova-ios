//
//  HomeScreenViewController.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 30/4/2026.
//

import Foundation
import UIKit


@MainActor
protocol HomeDisplayLogic: AnyObject {
    func displayMovies(viewModel: Home.FetchMovies.ViewModel)
}


class HomeScreenViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var interactor: HomeBusinessLogic?
    var router: HomeRoutingLogic?
    
    private var viewModel: Home.FetchMovies.ViewModel?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private var didSetInitialOffset = false
    
    var currentViewModel: Home.FetchMovies.ViewModel? {
        viewModel
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
        
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        view.backgroundColor = UIColor(named: "BackgroundColor")

        setupCollectionView()
        
        let request = Home.FetchMovies.Request()
        Task {
            await interactor?.fetchMovies(request: request)
        }
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !didSetInitialOffset else { return }
        didSetInitialOffset = true
        
        collectionView.setContentOffset(
            CGPoint(x: 0, y: -collectionView.adjustedContentInset.top),
            animated: false
        )
    }
    
    
    private func setupCollectionView()
    {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        
        collectionView.delegate = self
        configureDataSource()
        
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.identifier)
        
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { 
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .hero(let movie):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.identifier, for: indexPath) as! HeroCollectionViewCell
                cell.configure(with: movie)
                return cell
                
            case .movie(let movie):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
                cell.configure(with: movie)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
                for: indexPath
            ) as! SectionHeaderView
            
            let title = (indexPath.section == 1) ? "Top 10 Movies This Week" : "New Releases"
            header.configure(title: title)
            header.sectionIndex = indexPath.section
            
            header.onSeeAllTapped = { [weak self] section in
                guard let self else { return }
                
                switch section {
                case 1:
                    self.router?.routeToTop10(request: Home.FetchMovies.Request())
                case 2:
                    self.router?.routeToNewReleases(request: Home.FetchMovies.Request())
                    break
                default:
                    break
                }
            }
            
            return header
        }
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout {(sectionIndex, _) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                return self.createHeroSection()
            } else
            {
                return self.createMovieRowSection()
            }
        }
    }
    
    private func createHeroSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(500)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        return section
    }
    
    
    private func createMovieRowSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(220)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 16, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.createHeader()]
        return section
        
    }
    
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return header
    }
    
    
    private func setupNavigationBar() {
        let logoImageView = UIImageView(image: UIImage(named: "mova_logo"))
            logoImageView.contentMode = .scaleAspectFit
            
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                logoImageView.widthAnchor.constraint(equalToConstant: 30),
                logoImageView.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            let container = UIView()
            container.addSubview(logoImageView)
            NSLayoutConstraint.activate([
                logoImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                logoImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                container.widthAnchor.constraint(equalToConstant: 40),
                container.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            let leftItem = UIBarButtonItem(customView: container)
            navigationItem.leftBarButtonItem = leftItem
        
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: nil
        )
        
        let notificationButton = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .plain,
            target: self,
            action: nil
            
        )
        
        searchButton.tintColor = .white
        notificationButton.tintColor = .white
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        navigationItem.rightBarButtonItems = [notificationButton, spacer,  searchButton]
        
    }
    
}



extension HomeScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch selectedItem {
        case .hero(let movie), .movie(let movie):
            router?.routeToDetail(movieId: movie.id)
        }
    }
}


extension HomeScreenViewController: HomeDisplayLogic {
    
    
    @MainActor
    func displayMovies(viewModel: Home.FetchMovies.ViewModel) {
        
        //store viewmodel
        self.viewModel = viewModel
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.hero, .top10, .newReleases])
        
        if let hero = viewModel.heroMovie {
            snapshot.appendItems([.hero(hero)], toSection: .hero)
        }
        
        let top10Items = viewModel.top10.map { Item.movie($0) }
        snapshot.appendItems(top10Items, toSection: .top10)
        
        let newReleaseItems = viewModel.newReleases.map { Item.movie($0) }
        snapshot.appendItems(newReleaseItems, toSection: .newReleases)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
}
