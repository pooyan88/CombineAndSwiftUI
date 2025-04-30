//
//  PrefixExampleView.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/7/1404 AP.
//

import SwiftUI
import Combine

struct PrefixExampleView: View {
    @StateObject var vm = PrefixExampleViewModel()
    var body: some View {
        VStack {
            Text("Limit Results")
            Slider(value: $vm.itemsCount, in: 1...10, step: 1)
            Text("\(vm.itemsCount)")
            Button("Fetch data") {
                vm.fetch()
            }
        }
    }
}

final class PrefixExampleViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    @Published var itemsCount: Double = 5.0
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [String] = ["Result1", "Result2", "Result3", "Result4", "Result5"]
      cancellable = dataIn.publisher
            .prefix(Int(itemsCount))
            .sink { [unowned self] item in
                dataToView.append(item)
            }
    }
}

#Preview {
    PrefixExampleView()
}
