//
//  NewReleasesViewController.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 5/5/2026.
//

import UIKit
import Foundation

class NewReleasesViewController: UIViewController {
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    //var router: NewReleasesRoutingLogic?
    
    private var viewModel: NewReleases.ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "BackgroundColor")

        setupCollectionView()
        collectionView.reloadData()
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
        
        navigationItem.title = "New Releases"
        
    }
    
    
    func configure(with movies:
                   [Home.FetchMovies.ViewModel.DisplayedMovie])
    {
        viewModel = NewReleases.ViewModel(movies: movies)
    }
    
    private func setupCollectionView()
    {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(280))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}


extension NewReleasesViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = viewModel else { return 0 }
        
        return vm.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell,
              let vm = viewModel else { return UICollectionViewCell() }
        
        cell.configure(with: vm.movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel?.movies[indexPath.row] else { return }
        
        let router = HomeRouter()
        router.viewController = self
        router.routeToDetail(movieId: movie.id)
    }
    
}

extension NewReleasesViewController: HomeDisplayLogic
{
    
    @MainActor
    func displayMovies(viewModel: Home.FetchMovies.ViewModel) {
        self.viewModel = NewReleases.ViewModel(movies: viewModel.newReleases)
        collectionView.reloadData()
    }
    
}
