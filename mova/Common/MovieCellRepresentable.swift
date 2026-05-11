//
//  MovieCellRepresentable.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 8/5/2026.
//

import Foundation


protocol MovieCellRepresentable {
    var imageUrl: URL? { get }
    var rating: String { get }
}
