//
//  TryRemoveDuplicates.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct TryRemoveDuplicatesExample: View {
    @StateObject var vm = TryRemoveDuplicatesExampleViewModel()
    var body: some View {
        VStack {
            Button("Fetch") {
                vm.fetch()
            }
            List {
                ForEach(vm.dataToView, id: \.self) {
                    Text($0)
                }
                
            }
        }.alert(item: $vm.error) { error in
            Alert(title: Text(error.title), message: Text(error.message))
        }
    }
}

final class TryRemoveDuplicatesExampleViewModel: ObservableObject {

    struct MyError: Identifiable, Error {
        var id = UUID()
        var title = "Error"
        var message = "item not found"
    }

    @Published var dataToView: [String] = []
    @Published var error: MyError?
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [String] = ["Ali", "Hamid", "Hamid", "Invalid"]
     cancellable = dataIn.publisher
            .tryRemoveDuplicates { previousName, currentName in
                guard currentName != "Invalid" else { throw MyError() }
                return previousName == currentName
            }.sink { completion in
                if case .failure(let error) = completion {
                    self.error = error as? MyError
                }
            } receiveValue: { [unowned self] data in
                dataToView.append(data)
            }

    }
}

#Preview {
    TryRemoveDuplicatesExample()
}
