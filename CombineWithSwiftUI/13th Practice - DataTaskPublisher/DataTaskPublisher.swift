//
//  DataTaskPublisher.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/18/1404 AP.
//

import SwiftUI
import Combine

struct DataTaskPublisherView: View {
    @StateObject var viewModel = DataTaskPublisherViewModel2()
    var body: some View {
        VStack {
            List(viewModel.users, id: \.id) { user in
                Text("\(user.name)")
            }
            Button("fetch") {
                viewModel.fetch()
            }
            .alert(item: $viewModel.error) { error in
                Alert(title: Text(error.title), message: Text(error.body))
            }
        }
    }
}

final class DataTaskPublisherViewModel2: ObservableObject {
    struct APIError: Error, Identifiable {
        var id = UUID()
        var title = "Error"
        var body: String
    }
    @Published var users: [User] = []
    @Published var error: APIError?
    var cancellable: AnyCancellable?

    func fetch() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        cancellable = session.dataTaskPublisher(for: url)
            .map { data, response in
                return data
            }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                print("RESULT ===>", completion)
                if case .failure(let error) = completion {
                    self.error = APIError(body: error.localizedDescription)
                }
            } receiveValue: { users in
                self.users = users
            }
    }
}

#Preview {
    DataTaskPublisherView()
}
