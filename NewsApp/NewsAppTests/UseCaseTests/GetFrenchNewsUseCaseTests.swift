//
//  GetFrenchNewsUseCaseTests.swift
//  NewsApp
//
//  Created by Hamza on 08/09/2025.
//

import XCTest
@testable import NewsApp

final class GetFrenchNewsUseCaseTests: XCTestCase {

    var mockRepository: MockNewsRepository!
    var useCase: GetFrenchNewsUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockNewsRepository()
        useCase = GetFrenchNewsUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func test_execute_givenSuccess_returnsArticlesAndCallsRepositoryWithCorrectCountry() async throws {
        // Given
        let expectedArticles = [
            Article(title: "Test Title", description: "Test Desc", imageUrl: nil, articleUrl: URL(string: "https://test.com")!, sourceName: "Test Source")
        ]
        mockRepository.result = .success(expectedArticles)

        // When
        let actualArticles = try await useCase.execute()

        // Then
        XCTAssertEqual(actualArticles, expectedArticles, "The returned articles should match the expected articles.")
        XCTAssertEqual(mockRepository.getTopHeadlinesCallCount, 1, "The repository's getTopHeadlines method should be called exactly once.")
        XCTAssertEqual(mockRepository.receivedCountry, AppConstants.Configuration.defaultCountry, "The country passed to the repository should be the default one from constants.")
    }

    func test_execute_givenFailure_throwsError() async {
        // Given
        let expectedError = NSError(domain: "TestError", code: 123, userInfo: nil)
        mockRepository.result = .failure(expectedError)

        // When & Then
        do {
            _ = try await useCase.execute()
            XCTFail("The use case should have thrown an error, but it did not.")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, expectedError.domain)
            XCTAssertEqual(nsError.code, expectedError.code)
            XCTAssertEqual(mockRepository.getTopHeadlinesCallCount, 1, "The repository's getTopHeadlines method should still be called exactly once.")
        }
    }
}
