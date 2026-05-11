import Alamofire
import Foundation

enum HomeWorkerError: Error {
    case missingResponseData
    case decodingFailed
}

class HomeWorker
{
    private let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    private let token = Bundle.main.object(forInfoDictionaryKey: "TMDBAccessToken") as? String ?? ""
    
    func fetchPopular() async throws -> [Movie]
    {
        let url = "\(baseURL)/movie/popular"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        
        let data = try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }

        let movieResponse = try? JSONDecoder().decode(MovieResponse.self, from: data)
        guard let results = movieResponse?.results else {
            throw HomeWorkerError.decodingFailed
        }

        return results
    }
    
    func fetchNowPlaying() async throws -> [Movie]
    {
        let url = "\(baseURL)/movie/now_playing"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        
        let data = try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }

        let movieResponse = try? JSONDecoder().decode(MovieResponse.self, from: data)
        guard let results = movieResponse?.results else {
            throw HomeWorkerError.decodingFailed
        }

        return results
    }
    
    func fetchGenres() async throws -> [Int: String] {
        let url = "\(baseURL)/genre/movie/list"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "accept": "application/json"]
        
        let data: GenreResponse = try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers).responseDecodable(of: GenreResponse.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }

        var dict: [Int: String] = [:]
        data.genres.forEach { dict[$0.id] = $0.name }
        return dict
    }
    
    
    
    
}
