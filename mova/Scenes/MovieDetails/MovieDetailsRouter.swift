//
//  MovieDetailsRouter.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 8/5/2026.
//

import Foundation
import UIKit


enum MovieDetailsRouter {
    static func makeViewController(movieId: Int) -> MovieDetailsViewController? {
        let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
        guard let movieDetailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else {
            return nil
        }
        
        let interactor = MovieInteractor()
        let presenter = MovieDetailsPresenter()
        
        movieDetailsVC.movieId = movieId
        movieDetailsVC.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = movieDetailsVC
        
        return movieDetailsVC
    }
}
