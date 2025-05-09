//
//  DebounceExampleView.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 5/9/25.
//

import SwiftUI
import Combine

struct GitHubModel: Codable {
    let total_count: Int?
    let incomplete_results: Bool?
    let items: [Item]
    
    struct Item: Codable {
        let login: String
        let id: Int
        let node_id: String
    }
}

struct DebounceExampleView: View {
    @StateObject private var viewModel = DebounceExampleViewModel()

    var body: some View {
        VStack {
            Text(viewModel.debouncedText)
            
            TextField("Enter text", text: $viewModel.text)
                .padding(10)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .onChange(of: viewModel.text) { oldValue, newValue in
                    viewModel.debounce()
                }
        }
        .padding()
    }
}

final class DebounceExampleViewModel: ObservableObject {

    enum TextFieldError: Error {
        case noInput
    }

    @Published var text = ""
    @Published var debouncedText = ""
    var cancellable: AnyCancellable?

    func debounce() {
        cancellable = $text
            .handleEvents(receiveOutput: { value in
                    print("Typed text: \(value)")
                })
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .tryMap { text in
                guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                    throw TextFieldError.noInput
                }
                return text.replacingOccurrences(of: " ", with: "")
            }

            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.debouncedText = "SEARCH IS EMPTY"
                    }
                },
                receiveValue: { [weak self] search in
                    guard let self else { return }
                    Task {
                        do {
                            let result = try await self.makeRequest(query: search)
                            let firstUser = result.items.first?.login ?? "No users found"
                            await MainActor.run {
                                self.debouncedText = firstUser
                            }
                        } catch {
                            await MainActor.run {
                                self.debouncedText = "Search failed"
                            }
                            print("Request failed:", error)
                        }
                    }
                }
            )
    }

    func makeRequest(query: String) async throws -> GitHubModel {
        var components = URLComponents(string: "https://api.github.com/search/users")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

        guard let finalURL = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"

        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode(GitHubModel.self, from: data)
        dump(decodedData)
        return decodedData
    }
}


#Preview {
    DebounceExampleView()
}
