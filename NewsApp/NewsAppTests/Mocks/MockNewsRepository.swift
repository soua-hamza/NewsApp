//
//  MockNewsRepository.swift
//  NewsApp
//
//  Created by Hamza on 08/09/2025.
//

import Foundation

@testable import NewsApp

final class MockNewsRepository: NewsRepository {

    var result: Result<[Article], Error>!

    var getTopHeadlinesCallCount = 0
    var receivedCountry: String?

    func getTopHeadlines(country: String) async throws -> [Article] {
        getTopHeadlinesCallCount += 1
        receivedCountry = country

        // Return the predefined result
        switch result {
        case .success(let articles):
            return articles
        case .failure(let error):
            throw error
        case .none:
            fatalError("MockNewsRepository result was not set before calling getTopHeadlines")
        }
    }
}
