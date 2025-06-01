//
//  TryMapExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/11/1404 AP.
//

import SwiftUI
import Combine

struct TryMapExample: View {
    @StateObject var vm = TryMapExampleViewModel()
    var body: some View {
        VStack {
            Button("fetch") {
                vm.fetch()
            }
            List {
                ForEach(vm.dataToView, id: \.self) {
                    Text($0)
                }
            }
        }.alert(item: $vm.error) { error in
            Alert(title: Text(error.title), message: Text(error.description))
        }
    }
}

final class TryMapExampleViewModel: ObservableObject {

    struct MyError: Identifiable, Error, CustomStringConvertible {
        var id = UUID()
        var title = "Error"
        var description = "Invalid data found"
    }

    @Published var dataToView: [String] = []
    @Published var error: MyError?
    var cancellable: AnyCancellable?

    func fetch() {
        dataToView = []
        let dataIn: [String] = ["Result 1", "Result 2", "Invalid", "Result 4", "Result 5"]
       cancellable = dataIn.publisher
            .tryMap { dataInItem in
                guard dataInItem != "Invalid" else {
                    throw MyError()
                }
                return dataInItem
            }.sink { completion in
                if case .failure(let failure) = completion {
                    self.error = failure as? MyError
                }
            } receiveValue: { dataInItem in
                self.dataToView.append(dataInItem)
            }

    }
}

#Preview {
    TryMapExample()
}
