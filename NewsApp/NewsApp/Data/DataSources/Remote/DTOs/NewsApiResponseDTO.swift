//
//  NewsApiResponseDTO.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import Foundation

struct NewsApiResponseDTO: Codable, Sendable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}
