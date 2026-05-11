//
//  MovieDetailsPresenter.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 8/5/2026.
//

import Foundation

protocol MovieDetailsPresentationLogic {
    func presentMovieDetails(response: MovieDetails.FetchMovie.Response)
    func presentComments(response: MovieDetails.FetchComments.Response)
}

class MovieDetailsPresenter: MovieDetailsPresentationLogic {
    
    weak var viewController: MovieDetailsDisplayLogic?
    
    func presentMovieDetails(response: MovieDetails.FetchMovie.Response) {
        let imageBase = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String ?? ""

        let year = response.release_date?
            .split(separator: "-")
            .first
            .map(String.init) ?? "N/A"

        let country = response.production_countries?
            .first?
            .name ?? "N/A"

        let genres = response.genres?
            .map(\.name)
            .joined(separator: ", ") ?? "N/A"

        let displayedCast = response.credits?.cast.map { member in
            MovieDetails.FetchMovie.ViewModel.DisplayedCast(
                name: member.name,
                role: member.character ?? "Unknown",
                imageUrl: member.profile_path.flatMap { URL(string: imageBase + $0) }
            )
        } ?? []

        let displayedTrailers = response.videos?.results
            .filter { $0.type == "Trailer" }
            .map { video in
                MovieDetails.FetchMovie.ViewModel.DisplayedTrailer(
                    name: video.name,
                    duration: "Trailer",
                    thumbnailUrl: URL(string: "https://img.youtube.com/vi/\(video.key)/hqdefault.jpg"),
                    youtubeUrl: URL(string: "https://www.youtube.com/watch?v=\(video.key)")
                )
            } ?? []

        let displayedRecommendations = response.recommendations?.results.map { movie in
            MovieDetails.FetchMovie.ViewModel.DisplayedRecommendation(
                id: movie.id,
                imageUrl: movie.poster_path.flatMap { URL(string: imageBase + $0) },
                rating: String(format: "%.1f", movie.vote_average ?? 0.0)
            )
        } ?? []

        let displayedMovie = MovieDetails.FetchMovie.ViewModel.DisplayedMovie(
            title: response.title,
            backdropUrl: response.poster_path.flatMap { URL(string: imageBase + $0) },
            rating: String(format: "%.1f", response.vote_average ?? 0.0),
            year: year,
            country: country,
            description: response.overview,
            genres: genres,
            cast: displayedCast,
            trailers: displayedTrailers,
            recommendations: displayedRecommendations
        )

        let viewModel = MovieDetails.FetchMovie.ViewModel(movie: displayedMovie)
        viewController?.displayMovieDetails(viewModel: viewModel)
    }
    
    
    func presentComments(response: MovieDetails.FetchComments.Response) {
        let displayedComments = response.comments.map { comment in
            MovieDetails.FetchComments.ViewModel.DisplayedComment(
                userName: comment.userName,
                userProfileUrl: comment.userImage,
                text: comment.text,
                date: comment.timestamp,
                likes: comment.likeCount
            )
        }

        let viewModel = MovieDetails.FetchComments.ViewModel(
            displayedComments: displayedComments
        )

        viewController?.displayComments(viewModel: viewModel)
    }
}
