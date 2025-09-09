//
//  NewsListView.swift
//  NewsApp
//
//  Created by Hamza on 07/09/2025.
//

import SwiftUI

struct NewsListView: View {

    @StateObject private var viewModel: NewsListViewModel
    private let coordinator: AppCoordinator

    init(viewModel: NewsListViewModel, coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

    var body: some View {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading news...")
                case .success(let articles):
                    List(articles) { article in
                        Button(action: { coordinator.navigateTo(.detail(article: article)) }) {
                            NewsRowView(article: article)
                        }
                        .buttonStyle(.plain)
                    }.refreshable {
                        viewModel.handleRefresh()
                    }
                case .error(let message):
                    ScrollView {
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text(message)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(minHeight: 300)
                    }.refreshable {
                        viewModel.handleRefresh()
                    }
                }
            }
        .navigationTitle("USA News")
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct NewsRowView: View {
    let article: Article

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: article.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    Color.secondary.opacity(0.2)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 100, height: 80)
            .clipped()
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)

                Text(article.sourceName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
