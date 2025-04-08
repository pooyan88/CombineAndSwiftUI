//
//  DataTaskPublisherForImage.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/18/1404 AP.
//

import SwiftUI
import Combine

struct DataTaskPublisherForImage: View {

    @StateObject var viewModel = DataTaskPublisherForImageViewModel()

    var body: some View {
        VStack {
            viewModel.image
        }
        .onAppear {
            viewModel.fetch()
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text(error.title), message: Text(error.message))
        }
    }
}

final class DataTaskPublisherForImageViewModel: ObservableObject {

    struct ErrorForAlert: Identifiable, Error {
        var id: UUID = UUID()
        var title: String
        var message: String
    }
    @Published var error: ErrorForAlert?
    @Published var image: Image?
    var cancellable: AnyCancellable?

    func fetch() {
        let url = URL(string: "https://fastly.picsum.photos/id/108/300/200.jpg?hmac=MlabGxfxtDtB-KQ3LOCPKm2RZY7B6Xuaj8ERJzQTgoE")!
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        cancellable  = session.dataTaskPublisher(for: url)
            .map({$0.data})
            .tryMap { data in
                guard let uiImage = UIImage(data: data) else {
                    throw ErrorForAlert(title: "Error", message: "there is no valid image")
                }
                return Image(uiImage: uiImage)
            }
            .receive(on: RunLoop.main)
            .replaceError(with: Image(systemName: "xmark"))
            .sink(receiveValue: { [unowned self] image in
                self.image = image
            })

    }
}

#Preview {
    DataTaskPublisherForImage()
}
