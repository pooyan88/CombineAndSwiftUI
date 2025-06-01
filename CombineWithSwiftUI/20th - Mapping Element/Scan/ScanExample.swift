//
//  ScanExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/11/1404 AP.
//

import SwiftUI
import Combine

struct ScanExample: View {
    @StateObject var vm = ScanExampleViewModel()
    var body: some View {
        VStack {
            Button("Fetch") {
                vm.fetch()
            }
            List {
                ForEach(vm.dataToView, id: \.self) { item in
                    Text(item)
                }
            }
        }
    }
}

final class ScanExampleViewModel: ObservableObject {

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        dataToView = []
        let dataIn: [String] = ["1", "2", "3", "4", "5", "6", "4", "1", "2"]

        cancellable = dataIn.publisher
            .scan("") { accumulated, current in
                if !accumulated.contains(current) {
                    return accumulated + " " + current
                } else {
                    return accumulated
                }
            }.removeDuplicates()
            .sink { [unowned self] result in
                dataToView.append(result)
            }
    }
}

#Preview {
    ScanExample()
}
