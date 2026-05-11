//
//  MovieDetailsInteractor.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 8/5/2026.
//

import Foundation

protocol MovieDetailsBusinessLogic
{
    func fetchMovieData(request: MovieDetails.FetchMovie.Request) async
}

class MovieInteractor: MovieDetailsBusinessLogic
{
    var presenter : MovieDetailsPresentationLogic?
    var worker = MovieDetailsWorker()
    
    
    func fetchMovieData(request: MovieDetails.FetchMovie.Request) async {
        
        do {
            
            async let movieDetails = worker.fetchMovieDetails(id: request.movieId)
            
            async let comments = worker.fetchComments()
            
            let (details, mockComments) = try await (movieDetails, comments)
            
            
            await MainActor.run {
                presenter?.presentMovieDetails(response: details)
                presenter?.presentComments(response: MovieDetails.FetchComments.Response(comments: mockComments))
            }
            
        }
        catch
        {
            print(error)
        }
    }
}
