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
        collectionView.dataSource = self
        
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.identifier)
        
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



extension HomeScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        guard let vm = viewModel else { return 0 }
        
        switch section{
        case 0: return 1
        case 1: return vm.top10.count
        case 2: return vm.newReleases.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.identifier, for: indexPath) as! HeroCollectionViewCell
            if let hero = viewModel?.heroMovie {
                cell.configure(with: hero)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell,
                  let vm = viewModel else {
                return UICollectionViewCell()
            }
            
            let movie = (indexPath.section == 1) ? vm.top10[indexPath.row] : vm.newReleases[indexPath.row]
            cell.configure(with: movie)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vm = viewModel else { return }
        
        let movie: Home.FetchMovies.ViewModel.DisplayedMovie?
        switch indexPath.section {
        case 0:
            movie = vm.heroMovie
        case 1:
            movie = vm.top10[indexPath.row]
        case 2:
            movie = vm.newReleases[indexPath.row]
        default:
            movie = nil
        }
        
        guard let movie else { return }
        router?.routeToDetail(movieId: movie.id)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
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
        
        return UICollectionReusableView()
    }
}


extension HomeScreenViewController: HomeDisplayLogic {
    
    
    @MainActor
    func displayMovies(viewModel: Home.FetchMovies.ViewModel) {
        
        
        //store viewmodel
        self.viewModel = viewModel
        
        //reload ui on main screen
        collectionView.reloadData()
        
    }
}
