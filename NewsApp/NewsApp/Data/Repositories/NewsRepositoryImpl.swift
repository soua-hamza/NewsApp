//
//  NewsRepositoryImpl.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import Foundation


class NewsRepositoryImpl: NewsRepository {

    private let apiService: NewsAPIServiceProtocol

    init(apiService: NewsAPIServiceProtocol) {
        self.apiService = apiService
    }

    func getTopHeadlines(country: String) async throws -> [Article] {
        let responseDTO = try await apiService.getTopHeadlines(country: country)

        let articles = responseDTO.articles.compactMap { dto -> Article? in
            guard let urlString = dto.url, let articleUrl = URL(string: urlString) else {
                return nil
            }

            return Article(
                title: dto.title ?? "No Title",
                description: dto.description,
                imageUrl: URL(string: dto.urlToImage ?? ""),
                articleUrl: articleUrl,
                sourceName: dto.source.name ?? "Unknown Source"
            )
        }

        return articles
    }
}
