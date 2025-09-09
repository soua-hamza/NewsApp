//
//  NewsApp.swift
//  NewsApp
//
//  Created by Hamza on 06/09/2025.
//

import SwiftUI

@main
struct NewsApp: App {
    
    @StateObject private var coordinator: AppCoordinator

    init() {
        let diContainer = DIContainer()
        _coordinator = StateObject(wrappedValue: diContainer.makeAppCoordinator())
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.makeNewsListView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .detail(let article):
                            coordinator.makeNewsDetailView(for: article)
                        }
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
