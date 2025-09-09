//
//  MockGetFrenchNewsUseCase.swift
//  NewsApp
//
//  Created by Hamza on 08/09/2025.
//

import Foundation
@testable import NewsApp

final class MockGetFrenchNewsUseCase: GetFrenchNewsUseCaseProtocol {

    var result: Result<[Article], Error>!
    var executeCallCount = 0

    func execute() async throws -> [Article] {
        executeCallCount += 1

        switch result {
        case .success(let articles):
            return articles
        case .failure(let error):
            throw error
        case .none:
            fatalError("MockGetFrenchNewsUseCase result was not set before calling execute")
        }
    }
}
