//
//  Article.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import Foundation


struct Article: Equatable, Identifiable, Hashable, Sendable {
    var id: URL { articleUrl }

    let title: String
    let description: String?
    let imageUrl: URL?
    let articleUrl: URL
    let sourceName: String
}
