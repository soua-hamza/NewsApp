//
//  DIContainer.swift
//  NewsApp
//
//  Created by Hamza on 07/09/2025.
//

import Foundation

@MainActor
final class DIContainer {

    // MARK: - Properties

    private lazy var newsAPIService: NewsAPIServiceProtocol = NewsAPIService()

    private lazy var newsRepository: NewsRepository = NewsRepositoryImpl(
        apiService: self.newsAPIService
    )

    private lazy var getFrenchNewsUseCase: GetFrenchNewsUseCaseProtocol = GetFrenchNewsUseCase(
        repository: self.newsRepository
    )

    // MARK: - Object Creation

    func makeNewsListViewModel() -> NewsListViewModel {
        return NewsListViewModel(getFrenchNewsUseCase: self.getFrenchNewsUseCase)
    }

    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator(diContainer: self)
    }
}
