import Foundation


enum Home {
    enum FetchMovies {
        struct Request {} // Maybe 'page' if you add pagination later
        
        struct Response {
            let heroMovie: Movie?     
            let top10: [Movie]        // Uses the GLOBAL Movie model
            let newReleases: [Movie]   // Uses the GLOBAL Movie model
            let genreDictionary: [Int: String]
        }
        
        struct ViewModel {
            struct DisplayedMovie: Hashable, Sendable {
                let id: Int
                let title: String
                let imageUrl: URL?
                let rating: String
                let genres: String
            }
            let heroMovie: DisplayedMovie?
            let top10: [DisplayedMovie]
            let newReleases: [DisplayedMovie]
        }
    }
}

nonisolated enum Section: Int, CaseIterable, Hashable, Sendable {
    case hero
    case top10
    case newReleases
}

nonisolated enum Item: Hashable, Sendable {
    case hero(Home.FetchMovies.ViewModel.DisplayedMovie)
    case movie(Home.FetchMovies.ViewModel.DisplayedMovie)
}



nonisolated struct MovieResponse: Codable, Sendable {
    let results: [Movie]
}


nonisolated struct GenreResponse: Codable, Sendable {
    let genres: [Genre]
}

nonisolated struct Genre: Codable, Sendable {
    let id: Int
    let name: String
}




extension Home.FetchMovies.ViewModel.DisplayedMovie: MovieCellRepresentable {
}
