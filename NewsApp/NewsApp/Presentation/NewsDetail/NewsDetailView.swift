//
//  NewsDetailView.swift
//  NewsApp
//
//  Created by Hamza on 08/09/2025.
//

import SwiftUI

struct NewsDetailView: View {

    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: article.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ZStack {
                        Color.secondary.opacity(0.2)
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 220)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("By \(article.sourceName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Divider()

                    Text(article.description ?? "No description available.")
                        .font(.body)

                    Divider()

                    Link(destination: article.articleUrl) {
                        HStack {
                            Text("Read Full Story")
                            Image(systemName: "safari")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Article Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
