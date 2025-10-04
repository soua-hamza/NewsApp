//
//  NewsAPIService.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case apiKeyMissing
}

protocol NewsAPIServiceProtocol {
    func getTopHeadlines(country: String) async throws -> NewsApiResponseDTO
}

actor NewsAPIService: NewsAPIServiceProtocol {

    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        // Configure caching
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = URLCache(memoryCapacity: 50_000_000, diskCapacity: 100_000_000) // 50MB in-memory, 100MB on-disk
        self.session = URLSession(configuration: configuration)
    }

    func getTopHeadlines(country: String) async throws -> NewsApiResponseDTO {
        let apiKey = AppConstants.API.apiKey
        guard !apiKey.isEmpty else {
            throw NetworkError.apiKeyMissing
        }

        guard var components = URLComponents(string: AppConstants.API.baseUrl) else {
            throw NetworkError.invalidURL
        }

        components.path = AppConstants.API.Endpoints.topHeadlines
        components.queryItems = [
            URLQueryItem(name: AppConstants.API.Parameters.country, value: country),
            URLQueryItem(name: AppConstants.API.Parameters.apiKey, value: apiKey)
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest(url: url)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            do {
                let apiResponse = try JSONDecoder().decode(NewsApiResponseDTO.self, from: data)
                return apiResponse
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
