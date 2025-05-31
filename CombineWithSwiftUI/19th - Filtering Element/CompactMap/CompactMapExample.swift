//
//  CompactMapExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct CompactMapExample: View {
    @StateObject var vm = CompactMapExampleViewModel()
    var body: some View {
        VStack {
            Button("Fetch") {
                vm.fetch()
            }
            List {
                ForEach(vm.dataToView, id: \.self) { text in
                    Text(text)
                }
            }
        }
    }
}

final class CompactMapExampleViewModel: ObservableObject {

    struct DataModel {
        var name: String?
        var id: Int?
    }

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        let localData: [DataModel] = [
            DataModel(name: "Data1", id: 1),
            DataModel(name: nil, id: nil),
            DataModel(name: "Data2", id: 2),
            DataModel(name: "Data3", id: nil)
        ]
       cancellable = localData.publisher
            .compactMap { data in
                guard data.id != nil else { return nil }
                return data.name
            }.sink { [unowned self] string in
                dataToView.append(string)
            }
    }
}

#Preview {
    CompactMapExample()
}
