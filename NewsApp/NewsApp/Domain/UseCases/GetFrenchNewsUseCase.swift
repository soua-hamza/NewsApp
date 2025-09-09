//
//  GetFrenchNewsUseCase.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import Foundation

protocol GetFrenchNewsUseCaseProtocol {
    func execute() async throws -> [Article]
}

class GetFrenchNewsUseCase: GetFrenchNewsUseCaseProtocol {
    private let repository: NewsRepository

    init(repository: NewsRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Article] {
        return try await repository.getTopHeadlines(country: AppConstants.Configuration.defaultCountry)
    }
}
