//
//  TryCompactMapExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct TryCompactMapExample: View {
    @StateObject var vm = TryCompactMapExampleViewModel()
    var body: some View {
        VStack {
            ForEach(vm.dataToView, id: \.self) { item in
                Text(item)
            }
            Button("Fetch") {
                vm.fetch()
            }
        }.alert(item: $vm.error) { error in
            Alert(title: Text(error.title), message: Text(error.message))
        }
    }
}

final class TryCompactMapExampleViewModel: ObservableObject {

    struct MyError: Error, Identifiable {
        var id = UUID()
        var title = "Error"
        var message = "Failed to get the data"
    }

    @Published var dataToView: [String] = []
    @Published var error: MyError?
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [String?] = ["Data1", nil, "Data2", nil, "Invalid"]
       cancellable = dataIn.publisher
            .tryCompactMap { element in
                guard element != "Invalid" else { throw MyError() }
                return element
            }.sink { [unowned self] completion in
                if case .failure = completion {
                    error = MyError()
                }
            } receiveValue: { [unowned self] data in
                dataToView.append(data)
            }

    }
}

#Preview {
    TryCompactMapExample()
}

