//
//  Training.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/17/1404 AP.
//

import SwiftUI
import Combine


struct DataTaskView: View {

    @ObservedObject var viewModel: DataTaskPublisherViewModel
    
    var body: some View {
        VStack {
            if viewModel.showLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
            List(viewModel.users, id: \.id) { user in
                Text(user.name)
                Text(user.id.description)
                Text(user.username)
            }
            Button("fetch") {
                viewModel.fetch()
            }
            .alert(item: $viewModel.error) { error in
                Alert(title: Text(error.title),
                      message: Text(error.message),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

final class DataTaskPublisherViewModel: ObservableObject {

    struct User: Codable {
        let id: Int
        let name: String
        let username: String
    }

    struct ErrorAlert: Error, Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    @Published var users: [User] = []
    @Published var showLoading: Bool = false
    @Published var error: ErrorAlert?
    var cancellables: Set<AnyCancellable> = []


    func fetch() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        showLoading = true
        session.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                print("COMPLETION =====>", completion)
                if case .failure(let error) = completion {
                    showLoading = false
                    self.error = ErrorAlert(title: "error", message: error.localizedDescription)
                }
            } receiveValue: { [unowned self] items in
                showLoading = false
                users = items
            }.store(in: &cancellables)

    }
}

#Preview {
    DataTaskView(viewModel: DataTaskPublisherViewModel())
}
