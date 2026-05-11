//
//  HomePresenter.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 4/5/2026.
//

import Foundation

protocol HomePresentationLogic {
    func presentMovies(response: Home.FetchMovies.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentMovies(response: Home.FetchMovies.Response) {
        let imageBase = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String ?? ""
        

        func mapMovie(_ movie: Movie?) -> Home.FetchMovies.ViewModel.DisplayedMovie? {
            guard let movie = movie else { return nil }
            
            let genreNames = movie.genre_ids?.compactMap { response.genreDictionary[$0] } ?? []
            let genreString = genreNames.prefix(3).joined(separator: ", ")
            
            let fullPath = imageBase + (movie.poster_path ?? "")
            
            return Home.FetchMovies.ViewModel.DisplayedMovie(
                id: movie.id,
                title: movie.title ?? "",
                imageUrl: URL(string: fullPath),
                rating: String(format: "%.1f", movie.vote_average ?? 0.0),
                genres: genreString
            )
        }
        
        let viewModel = Home.FetchMovies.ViewModel(
            heroMovie: mapMovie(response.heroMovie),
            top10: response.top10.compactMap { mapMovie($0) },
            newReleases: response.newReleases.compactMap { mapMovie($0) }
            )
        
        viewController?.displayMovies(viewModel: viewModel)
    }
    
    func presentComments(response: Home.FetchMovies.Response) {
        
    }
    
    
}
