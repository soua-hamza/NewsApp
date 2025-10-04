//
//  ArticleDTO.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import Foundation

struct ArticleDTO: Codable, Sendable {
    let source: SourceDTO
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct SourceDTO: Codable, Sendable {
    let id: String?
    let name: String?
}
