//
//  Training.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/17/1404 AP.
//

import SwiftUI
import Combine


struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let username: String
}

struct ListProvider: View {

    var user: User

    var body: some View {
        VStack {
            Text(user.name)
            Text(user.id.description)
            Text(user.username)
        }
    }
}

struct DataTaskView: View {

    @ObservedObject var viewModel: DataTaskPublisherViewModel
    
    var body: some View {
        VStack {
            if viewModel.showLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
            withAnimation {
                List(viewModel.users, id: \.id) { user in
                    ListProvider(user: user)
                }
            }
            Button("fetch") {
                viewModel.fetch()
            }
            .background(Color.clear)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .tint(.blue)
            .padding()
            .alert(item: $viewModel.error) { error in
                Alert(title: Text(error.title),
                      message: Text(error.message),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

final class DataTaskPublisherViewModel: ObservableObject {

    struct ErrorAlert: Error, Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    @Published var users: [User] = []
    @Published var showLoading: Bool = false
    @Published var error: ErrorAlert?
    var webService = WebService(requestManager: .getUsers)
    var cancellables: Set<AnyCancellable> = []


    func fetch() {
        showLoading = true
        Task { @MainActor in
            do {
                users = try await webService.getUsers()
                showLoading = false
            } catch {
                showLoading = false
                print(error)
            }
        }
    }
}

enum RequestError: Error {
    case invalidURL
}

enum RequestManager {
    case getUsers

    func getURLRequest() throws -> URLRequest {
        guard let url = URL(string: RequestURLManager(requestManager: self).getURL()) else {
            throw RequestError.invalidURL
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}

class RequestURLManager {
    var requestManager: RequestManager

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }

    func getURL() -> String {
        switch requestManager {
        case .getUsers:
            return "https://jsonplaceholder.typicode.com/users"
        }
    }
}

class RequestHeaderManager {

    func configureHeaders(for request: URLRequest) -> URLRequest {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer your_token_here", forHTTPHeaderField: "Authorization")
        // Add more headers if needed
        return request
    }
}

class WebService {

    var requestManager: RequestManager
    var cancellables: Set<AnyCancellable> = []

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }

    func baseRequest<T: Codable>(for requestManager: RequestManager, type: T.Type) async throws -> T {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = try! requestManager.getURLRequest()
        return try await withCheckedThrowingContinuation { continuation in
            session.dataTaskPublisher(for: url)
                .map({$0.data})
                .decode(type: type, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Request Succeed")
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        print("Error: \(error)")
                    }
                } receiveValue: { value in
                    dump(value)
                    continuation.resume(with: .success(value))
                }.store(in: &cancellables)
        }
    }
}

extension WebService {

    func getUsers() async throws -> [User] {
        return try await baseRequest(for: .getUsers, type: [User].self)
    }
}

struct CancellableView: View {
    @StateObject var viewModel = CancellableViewViewModel()
    var body: some View {
        VStack {
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
        }.onAppear {
            viewModel.fetch()
        }
    }
}

final class CancellableViewViewModel: ObservableObject {
    enum CustomError: Error {
        case bombDetected
    }
    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    init() {

    }

    func fetch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let dataIn = ["A", "B", "C", "🧨", "E", "F"]

            dataIn.publisher
                .tryMap { [unowned self] item in
                    if item == "🧨" {
                        throw CustomError.bombDetected
                    }
                    return item
                }
                .catch { error in
                    Empty(completeImmediately: true)
                }.sink { [unowned self] item in
                    dataToView.append(item)
                }
        }
    }
}

struct CancelPipeLineView: View {
    @StateObject var viewModel = CancelPipeLineViewModel()
    var body: some View {
        VStack {
            HStack {
                TextField("Text", text: $viewModel.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(Color.gray)
                switch viewModel.status {
                case .ok:
                    Image(systemName: "checkmark")
                case .invalid:
                    Image(systemName: "xmark")
                case .notEvaluated:
                    EmptyView()
                }
            }.padding()
        }
    }
}

final class CancelPipeLineViewModel: ObservableObject {
    enum CreditStatus { case ok, invalid, notEvaluated}
    @Published var text: String = ""
    @Published var status: CreditStatus = .notEvaluated

    init() {
        $text
            .map { character -> CreditStatus in
                guard !character.isEmpty else { return .notEvaluated }
                if character.count == 16 {
                    return .ok
                } else {
                    return .invalid
                }
            }.assign(to: &$status)
    }
}

struct ContainsExample: View {
    @StateObject var vm = ContainsExampleViewModel()
    var body: some View {
        VStack {
            Text(vm.description)
            Toggle("heating", isOn: $vm.heating)
            Toggle("air condition", isOn: $vm.airConditioning)
            Toggle("bathroom", isOn: $vm.basement)
            Toggle("basement", isOn: $vm.basement)
        }.padding()
            .onAppear {
                vm.fetch()
            }
    }
}

final class ContainsExampleViewModel: ObservableObject {

    @Published var heating: Bool = false
    @Published var airConditioning: Bool = false
    @Published var basement: Bool = false
    @Published var bathroom: Bool = false
    @Published var description: String = ""
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [String] = ["heating", "basement", "airconditioning", "bathroom"]
        cancellable = dataIn.publisher
            .prefix(2)
            .sink { [unowned self] string in
                description += string + "\n"
            }
        dataIn.publisher
            .contains("heating")
            .assign(to: &$heating)
        dataIn.publisher
            .contains("airconditioning")
            .assign(to: &$airConditioning)
        dataIn.publisher
            .contains("basement")
            .assign(to: &$basement)
        dataIn.publisher
            .contains("bathroom")
            .assign(to: &$bathroom)
    }
}

struct DropUntilOutputFromExample2: View {
    
    @StateObject var vm = DropUntilOutputFromExample2ViewModel()
    var body: some View {
        VStack {
            Button("Start pipeline") {
                vm.start()
            }
            List {
                ForEach(vm.list, id: \.self) { item in
                    Text(item)
                }
            }
            Button("Clear") {
                vm.list.removeAll()
                vm.cancellable?.cancel()
            }
        }
    }
}

final class DropUntilOutputFromExample2ViewModel: ObservableObject {
    
    @Published var list: [String] = []
    var cancellable: AnyCancellable?
    
    func start() {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [unowned self] timer in
                list.append(dateFormatter.string(from: timer))
            }
    }
    
}


#Preview {
    DropUntilOutputFromExample2()
}
