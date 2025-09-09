//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import Foundation

protocol NewsRepository {
    
    func getTopHeadlines(country: String) async throws -> [Article]
}
