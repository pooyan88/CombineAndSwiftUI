//
//  TryFilterExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct TryFilterExample: View {
    @StateObject var vm = TryFilterExampleViewModel()
    var body: some View {
        VStack {
            HStack {
                Button {

                } label: {
                    Text("Animal")
                        .opacity(0.3)
                }
                Spacer()
                Button("Human") {
                    vm.fetch(type: .human)
                }
                Spacer()
                Button("All") {
                    vm.fetch()
                }
            }.padding()
            List {
                ForEach(vm.filteredData) { item in
                    Text(item.name)
                }
            }
        }.alert(item: $vm.error) { error in
            Alert(title: Text(error.title), message: Text(error.message))
        }
    }
}

final class TryFilterExampleViewModel: ObservableObject {

    enum DataType {
        case human
        case animal
        case all
    }

    struct MyError: Error, Identifiable {
        var id = UUID()
        var title = "Error"
        var message = "this type not supported"
    }

    struct DataModel: Identifiable {
        var id = UUID()
        var name: String
        var type: [DataType]
    }

    @Published var filteredData: [DataModel] = []
    @Published var error: MyError?
    var cancellable: AnyCancellable?

    init() {
        fetch()
    }

    func fetch(type: DataType = .all) {
        filteredData = []
        let dataIn: [DataModel] = [
            DataModel(name: "Ali", type: [.human, .all]),
            DataModel(name: "wall", type: [.all]),
            DataModel(name: "Hamid", type: [.human, .all]),
            DataModel(name: "dog", type: [.animal, .all]),
            DataModel(name: "cat", type: [.animal, .all]),
        ]
       cancellable = dataIn.publisher
            .tryFilter({ incomingData in
                guard !incomingData.type.contains(.animal) else { throw MyError()}
                return incomingData.type.contains(type)
            })
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    self.error = failure as? MyError
                }
            }, receiveValue: { [unowned self] data in
                filteredData.append(data)
            })
    }
}

#Preview {
    TryFilterExample()
}
