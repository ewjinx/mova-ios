import Foundation

protocol HomeBusinessLogic
{
    func fetchMovies(request: Home.FetchMovies.Request) async
}

class HomeInteractor: HomeBusinessLogic
{
    var presenter: HomePresentationLogic?
    var worker = HomeWorker()
    
    var genreDictionary: [Int: String] = [:] // local storage
    
    func fetchMovies(request: Home.FetchMovies.Request) async
    {
        do {
            async let fetchedGenres = worker.fetchGenres()      //concurrent
            async let fetchedPopular = worker.fetchPopular()    //concurrent
            async let fetchedNowPlaying = worker.fetchNowPlaying()  //concurrent

            let genreDictionary = try await fetchedGenres
            let popular = try await fetchedPopular
            let nowPlaying = try await fetchedNowPlaying

            self.genreDictionary = genreDictionary

            let response = Home.FetchMovies.Response(
                heroMovie: nowPlaying.randomElement(),
                top10: Array(popular.prefix(10)),
                newReleases: nowPlaying,
                genreDictionary: genreDictionary
            )

            await MainActor.run {
                self.presenter?.presentMovies(response: response)
            }
        } catch {
            let response = Home.FetchMovies.Response(
                heroMovie: nil,
                top10: [],
                newReleases: [],
                genreDictionary: [:]
            )

            await MainActor.run {      
                self.presenter?.presentMovies(response: response)
            }
        }
    }
}
