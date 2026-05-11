//
//  HomeRouter.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 4/5/2026.
//

import Foundation
import UIKit

protocol HomeRoutingLogic {
    func routeToDetail(movieId: Int)
    func routeToTop10(request: Home.FetchMovies.Request)
    func routeToNewReleases(request: Home.FetchMovies.Request)
}



class HomeRouter: HomeRoutingLogic {
    weak var viewController: UIViewController?
    weak var dataStore: HomeInteractor?
    
    func routeToDetail(movieId: Int) {
        guard let movieDetailsVC = MovieDetailsRouter.makeViewController(movieId: movieId) else { return }
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    func routeToTop10(request: Home.FetchMovies.Request) {
        let storyboard = UIStoryboard(name: "Top10", bundle: nil)
        guard let top10VC = storyboard.instantiateViewController(withIdentifier: "Top10") as? Top10ViewController else { return }

        if let homeViewController = viewController as? HomeScreenViewController,
           let top10Movies = homeViewController.currentViewModel?.top10 {
            top10VC.configure(with: top10Movies)
        }

        viewController?.navigationController?.pushViewController(top10VC, animated: true)
    }
    
    func routeToNewReleases(request: Home.FetchMovies.Request) {
        
        let storyboard = UIStoryboard(name: "NewReleases", bundle: nil)
        guard let newReleasesVC = storyboard.instantiateViewController(withIdentifier: "NewReleases") as? NewReleasesViewController else { return }
        
        if let homeViewController = viewController as? HomeScreenViewController,
           let newReleasesMovies = homeViewController.currentViewModel?.newReleases {
            newReleasesVC.configure(with: newReleasesMovies)
        }
        
        viewController?.navigationController?.pushViewController(newReleasesVC, animated: true)
        
    }
}
