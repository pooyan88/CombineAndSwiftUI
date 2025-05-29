//
//  TimeoutExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 5/29/25.
//

import SwiftUI
import Combine

struct TimeoutExample: View {
    @StateObject private var viewModel = TimeoutExampleViewModel()
    var body: some View {
        VStack {
            Button("Fetch") {
               viewModel.fetch()
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }.alert(item: $viewModel.timeoutError) { timeoutError in
            Alert(title: Text(timeoutError.title), message: Text(timeoutError.message))
            }
    }
}

final class TimeoutExampleViewModel: ObservableObject {
    
    struct TimeOutError: Error, Identifiable {
        let id = UUID()
        let title = "Timeout"
        let message = "Please try again later"
    }
    @Published var dataToView: [String] = []
    @Published var isLoading: Bool = false
    @Published var timeoutError: TimeOutError?
    var cancellable: AnyCancellable?
    
    
    func fetch() {
        isLoading = true
        let url = URL(string: "https://bigmountainstudio.com/nothing")!
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .timeout(.seconds(0.1), scheduler: RunLoop.main, customError: {URLError(.timedOut)})
            .map { data, response in
                return data
            }.decode(type: String.self, decoder: JSONDecoder())
            .sink { completion in
                self.isLoading = false
                if case .failure = completion {
                    self.timeoutError = TimeOutError()
                }
            } receiveValue: { decodedData in
                self.isLoading = false
                self.dataToView.append(decodedData)
            }

    }
}

#Preview {
    TimeoutExample()
}
