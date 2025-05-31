//
//  FilterExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct FilterExample: View {
    @StateObject var vm = FilterExampleViewModel()
    var body: some View {
        VStack {
            HStack {
                Button("Human") {
                    vm.fetch(type: .human)
                }
                Spacer()
                Button("Animal") {
                    vm.fetch(type: .animal)
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
        }
    }
}

final class FilterExampleViewModel: ObservableObject {

    enum DataType {
        case human
        case animal
        case all
    }

    struct DataModel: Identifiable {
        var id = UUID()
        var name: String
        var type: [DataType]
    }

    @Published var filteredData: [DataModel] = []
    var cancellable: AnyCancellable?

    init() {
        fetch()
    }

    func fetch(type: DataType = .all) {
        filteredData = []
        let dataIn: [DataModel] = [
            DataModel(name: "Ali", type: [.human, .all]),
            DataModel(name: "cat", type: [.animal, .all]),
            DataModel(name: "dog", type: [.animal, .all]),
            DataModel(name: "wall", type: [.all]),
            DataModel(name: "Hamid", type: [.human, .all]),
        ]
       cancellable = dataIn.publisher
            .filter { incommingData in
                return incommingData.type.contains(type)
            }
            .sink { [unowned self] fetchedData in
                filteredData.append(fetchedData)
            }
    }
}

#Preview {
    FilterExample()
}
