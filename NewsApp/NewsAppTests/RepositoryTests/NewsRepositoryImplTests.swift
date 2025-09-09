//
//  NewsRepositoryImplTests.swift
//  NewsApp
//
//  Created by Hamza on 08/09/2025.
//

import XCTest
@testable import NewsApp

final class NewsRepositoryImplTests: XCTestCase {

    var mockAPIService: MockNewsAPIService!
    var repository: NewsRepositoryImpl!

    override func setUp() {
        super.setUp()
        mockAPIService = MockNewsAPIService()
        repository = NewsRepositoryImpl(apiService: mockAPIService)
    }

    override func tearDown() {
        mockAPIService = nil
        repository = nil
        super.tearDown()
    }

    func test_getTopHeadlines_givenSuccess_mapsDTOsToDomainModels() async throws {
        // Given
        let articleDTO = ArticleDTO(
            source: SourceDTO(id: "1", name: "Test Source"),
            author: "Author",
            title: "Test Title",
            description: "Test Desc",
            url: "https://test.com/article",
            urlToImage: "https://test.com/image.jpg",
            publishedAt: "2024-01-01T12:00:00Z",
            content: "Content"
        )
        let responseDTO = NewsApiResponseDTO(status: "ok", totalResults: 1, articles: [articleDTO])
        mockAPIService.result = .success(responseDTO)

        // When
        let articles = try await repository.getTopHeadlines(country: "us")

        // Then
        XCTAssertEqual(articles.count, 1)
        XCTAssertEqual(articles.first?.title, "Test Title")
        XCTAssertEqual(articles.first?.articleUrl, URL(string: "https://test.com/article")!)
        XCTAssertEqual(articles.first?.imageUrl, URL(string: "https://test.com/image.jpg")!)
        XCTAssertEqual(mockAPIService.getTopHeadlinesCallCount, 1)
    }

    func test_getTopHeadlines_givenDTOWithMissingURL_filtersArticle() async throws {
        // Given
        let validArticleDTO = ArticleDTO(source: SourceDTO(id: "Valid", name: "Valid"), author: nil, title: "Valid", description: nil, url: "https://valid.com", urlToImage: nil, publishedAt: nil, content: nil)
        let invalidArticleDTO = ArticleDTO(source: SourceDTO(id: "Invalid", name: "Invalid"), author: nil, title: "Invalid", description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil) // Missing URL
        let responseDTO = NewsApiResponseDTO(status: "ok", totalResults: 2, articles: [validArticleDTO, invalidArticleDTO])
        mockAPIService.result = .success(responseDTO)

        // When
        let articles = try await repository.getTopHeadlines(country: "us")

        // Then
        XCTAssertEqual(articles.count, 1, "The repository should filter out articles with no URL.")
        XCTAssertEqual(articles.first?.title, "Valid")
    }

    func test_getTopHeadlines_givenAPIServiceFailure_throwsError() async {
        // Given
        let expectedError = NetworkError.requestFailed(NSError(domain: "Network", code: 500))
        mockAPIService.result = .failure(expectedError)

        // When & Then
        do {
            _ = try await repository.getTopHeadlines(country: "fr")
            XCTFail("The repository should have thrown an error.")
        } catch {
            XCTAssertNotNil(error)
            XCTAssertEqual(mockAPIService.getTopHeadlinesCallCount, 1)
        }
    }
}
