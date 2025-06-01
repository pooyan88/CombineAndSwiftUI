//
//  ReplaceNilExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/11/1404 AP.
//

import SwiftUI
import Combine

struct ReplaceNilExample: View {
    @StateObject var vm = ReplaceNilExampleViewModel()
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
        }
    }
}

final class ReplaceNilExampleViewModel: ObservableObject {

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [String?] = ["Result 1", "Result 2", nil, "Result 3"]
       cancellable = dataIn.publisher
            .replaceNil(with: "My Specify Data")
            .sink { optionalString in
                self.dataToView.append(optionalString)
            }
    }

}

#Preview {
    ReplaceNilExample()
}
