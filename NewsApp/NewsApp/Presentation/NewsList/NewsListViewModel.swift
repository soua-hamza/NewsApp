//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Hamza on 07/09/2025.
//

import Foundation
import Combine

enum NewsListState: Equatable {
    case loading
    case success(articles: [Article])
    case error(message: String, id: UUID = UUID())

    static func == (lhs: NewsListState, rhs: NewsListState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .success(lhsArticles), let .success(rhsArticles)):
            return lhsArticles == rhsArticles
        case (let .error(_, lhsId), let .error(_, rhsId)):
            return lhsId == rhsId
        default:
            return false
        }
    }
}


@MainActor
class NewsListViewModel: ObservableObject {

    @Published private(set) var state: NewsListState = .loading

    private let getFrenchNewsUseCase: GetFrenchNewsUseCaseProtocol

    init(getFrenchNewsUseCase: GetFrenchNewsUseCaseProtocol) {
        self.getFrenchNewsUseCase = getFrenchNewsUseCase
    }

    func onAppear() {
        Task {
            await fetchNews()
        }
    }
    
    func handleRefresh() {
        Task {
            await fetchNews()
        }
    }
    
    private func fetchNews() async {
        if case .loading = state {} else {
            state = .loading
        }
        
        do {
            let articles = try await getFrenchNewsUseCase.execute()
            if articles.isEmpty {
                state = .error(message: "No articles found.")
            } else {
                state = .success(articles: articles)
            }
        } catch let networkError as NetworkError {
            switch networkError {
            case .apiKeyMissing:
                state = .error(message: "API Key is missing. Please configure it in AppConstants.swift.")
            case .invalidURL:
                state = .error(message: "The request URL is invalid.")
            case .invalidResponse:
                state = .error(message: "Received an invalid response from the server.")
            default:
                state = .error(message: "An unexpected network error occurred.")
            }
        } catch {
            state = .error(message: "An unexpected error occurred: \(error.localizedDescription)")
        }
    }
    

}
