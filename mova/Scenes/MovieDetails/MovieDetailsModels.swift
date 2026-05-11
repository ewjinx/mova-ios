import UIKit
import Foundation

enum MovieDetails {
    
    
    enum FetchMovie {
        struct Request {
            let movieId: Int
        }
        
        struct Response: Codable {
            let id: Int
            let title: String
            let overview: String
            let poster_path: String?
            let release_date: String?
            let vote_average: Double?
            let runtime: Int?
            let genres: [Genre]?
            let production_countries: [Country]?
            let credits: CreditsResponse?
            let videos: VideoResponse?
            let recommendations: MovieRecommendationResponse?
            
            struct Genre: Codable { let name: String }
            struct Country: Codable { let name: String }
            
            struct CreditsResponse: Codable {
                let cast: [CastMember]
                let crew: [CrewMember]
            }
            
            struct VideoResponse: Codable {
                let results: [VideoItem]
            }
            
            struct MovieRecommendationResponse: Codable {
                let results: [MovieRecommendation]
            }
        }
        
        struct ViewModel {
            struct DisplayedMovie {
                let title: String
                let backdropUrl: URL?
                let rating: String
                let year: String
                let country: String
                let description: String
                let genres: String
                let cast: [DisplayedCast]
                let trailers: [DisplayedTrailer]
                let recommendations: [DisplayedRecommendation]
            }
            
            struct DisplayedCast {
                let name: String
                let role: String
                let imageUrl: URL?
            }
            
            struct DisplayedTrailer {
                let name: String
                let duration: String
                let thumbnailUrl: URL?
                let youtubeUrl: URL?
            }
            
            struct DisplayedRecommendation {
                let id: Int
                let imageUrl: URL?
                let rating: String
            }
            
            let movie: DisplayedMovie
        }
    }
    
    
    enum FetchComments {
        struct Request {}
        
        struct Response {
            let comments: [Comment]
        }
        
        struct ViewModel {
            struct DisplayedComment {
                let userName: String
                let userProfileUrl: String?
                let text: String
                let date: String
                let likes: Int
            }
            let displayedComments: [DisplayedComment]
        }
    }
}

struct CastMember: Codable {
    let name: String
    let character: String?
    let profile_path: String?
}

struct CrewMember: Codable {
    let name: String
    let job: String
}

struct VideoItem: Codable {
    let name: String
    let key: String
    let type: String
}

struct MovieRecommendation: Codable {
    let id: Int
    let poster_path: String?
    let vote_average: Double?
}

struct Comment: Codable {
    let userName: String
    let userImage: String
    let text: String
    let timestamp: String
    let likeCount: Int
}


extension MovieDetails.FetchMovie.ViewModel.DisplayedRecommendation: MovieCellRepresentable {
}
