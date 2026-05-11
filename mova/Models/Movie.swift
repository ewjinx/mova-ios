//
//  Movie.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 4/5/2026.
//



nonisolated struct Movie: Codable, Sendable
{
    let id: Int
    let title: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let release_date: String?
    let vote_average: Double?
    let genre_ids: [Int]?
}
