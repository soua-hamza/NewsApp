//
//  NewsListViewModelTests.swift
//  NewsApp
//
//  Created by Hamza on 08/09/2025.
//

import XCTest
import Combine
@testable import NewsApp

@MainActor
final class NewsListViewModelTests: XCTestCase {

    var mockUseCase: MockGetFrenchNewsUseCase!
    var viewModel: NewsListViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockGetFrenchNewsUseCase()
        viewModel = NewsListViewModel(getFrenchNewsUseCase: mockUseCase)
        cancellables = []
    }

    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func test_initialState_isLoading() {
        // Given a new ViewModel
        // Then its initial state should be .loading
        XCTAssertEqual(viewModel.state, .loading)
    }

    func test_onAppear_givenSuccess_updatesStateToSuccess() async {
        // Given
        let expectedArticles = [Article(title: "Test", description: nil, imageUrl: nil, articleUrl: URL(string: "https://test.com")!, sourceName: "Test")]
        mockUseCase.result = .success(expectedArticles)

        let expectation = XCTestExpectation(description: "Wait for state to update to success")

        // When
        viewModel.$state
            .dropFirst() // Ignore the initial .loading state
            .sink { state in
                if case .success(let articles) = state {
                    XCTAssertEqual(articles, expectedArticles)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.onAppear()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    func test_onAppear_givenFailure_updatesStateToError() async {
        // Given
        let expectedError = NetworkError.invalidResponse
        mockUseCase.result = .failure(expectedError)

        let expectation = XCTestExpectation(description: "Wait for state to update to error")

        // When
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertTrue(message.contains("invalid response"), "Error message should be about an invalid response.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.onAppear()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    func test_onAppear_givenEmptyArticleList_updatesStateToError() async {
        // Given
        mockUseCase.result = .success([])

        let expectation = XCTestExpectation(description: "Wait for state to update to error for empty list")

        // When
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, "No articles found.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.onAppear()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
