//
//  MockNewsAPIService.swift
//  NewsApp
//
//  Created by Hamza on 08/09/2025.
//

import Foundation
@testable import NewsApp

final class MockNewsAPIService: NewsAPIServiceProtocol {

    var result: Result<NewsApiResponseDTO, Error>!
    var getTopHeadlinesCallCount = 0

    func getTopHeadlines(country: String) async throws -> NewsApiResponseDTO {
        getTopHeadlinesCallCount += 1

        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        case .none:
            fatalError("MockNewsAPIService result was not set before calling getTopHeadlines")
        }
    }
}
