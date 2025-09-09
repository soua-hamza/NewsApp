//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Hamza on 07/09/2025.
//

import SwiftUI
import Combine

enum Route: Hashable {
    case detail(article: Article)
}

@MainActor
final class AppCoordinator: ObservableObject {

    @Published var path = NavigationPath()

    private let diContainer: DIContainer

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    // MARK: - ViewModel Creation

    func makeNewsListViewModel() -> NewsListViewModel {
        return diContainer.makeNewsListViewModel()
    }

    // MARK: - Navigation

    func navigateTo(_ route: Route) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    // MARK: - View Builders

    @ViewBuilder
    func makeNewsListView() -> some View {
        NewsListView(
            viewModel: makeNewsListViewModel(),
            coordinator: self
        )
    }

    @ViewBuilder
    func makeNewsDetailView(for article: Article) -> some View {
        NewsDetailView(article: article)
    }
}
