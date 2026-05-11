//
//  MovieDetailsWorker.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 8/5/2026.
//

import Alamofire
import Foundation

enum MovieWorkerError: Error {
    case decodingFailed
    case invalidURL
}

class MovieDetailsWorker {
    private let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    private let token = Bundle.main.object(forInfoDictionaryKey: "TMDBAccessToken") as? String ?? ""

    func fetchMovieDetails(id: Int) async throws -> MovieDetails.FetchMovie.Response {
        let url = "\(baseURL)/movie/\(id)"
        let parameters: [String: String] = [
            "append_to_response": "credits,videos,recommendations"
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "application/json"
        ]
        
        let data = try await withCheckedThrowingContinuation { continuation in
            AF.request(url, parameters: parameters, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        do {
            let detailResponse = try JSONDecoder().decode(MovieDetails.FetchMovie.Response.self, from: data)
            return detailResponse
        } catch {
            print("\(error)")
            throw MovieWorkerError.decodingFailed
        }
    }
    
    func fetchComments() async throws -> [Comment] {
        guard let url = Bundle.main.url(forResource: "Comments", withExtension: "json") else {
            throw MovieWorkerError.invalidURL
        }

        do {
            let data = try Data(contentsOf: url)
            let comments = try JSONDecoder().decode([Comment].self, from: data)
            return comments
        } catch {
            throw MovieWorkerError.decodingFailed
        }
    }
}
