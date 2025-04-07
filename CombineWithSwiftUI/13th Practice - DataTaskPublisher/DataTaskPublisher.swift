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
            .onAppear {
                viewModel.fetch()
            }
        }
    }
}

final class DataTaskPublisherViewModel2: ObservableObject {
    @Published var users: [User] = []
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
            .sink { completion in
                print("RESULT ===>", completion)
            } receiveValue: { users in
                self.users = users
            }
    }
}

#Preview {
    DataTaskPublisherView()
}
