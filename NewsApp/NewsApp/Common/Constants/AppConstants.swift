//
//  AppConstants.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import Foundation

struct AppConstants {

    struct API {
        static let apiKey = "df8b383981934ed2a8002a8b656552ff"

        static let baseUrl = "https://newsapi.org"

        struct Endpoints {
            static let topHeadlines = "/v2/top-headlines"
        }

        struct Parameters {
            static let country = "country"
            static let apiKey = "apiKey"
        }
    }

    struct Configuration {
        static let defaultCountry = "us"
    }
}
