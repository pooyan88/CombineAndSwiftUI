//
//  Min.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/1/1404 AP.
//

import SwiftUI
import Combine

struct MinExampleView: View {

    @StateObject var vm = MinExampleViewModel()
    var body: some View {
        VStack {
            List {
                Section(footer: Text("Min: \(vm.minName)").bold()) {
                    ForEach(vm.names, id: \.self) { name in
                        Text(name)
                    }
                }
            }
            List {
                Section(footer: Text("Min: \(vm.minNumber)")) {
                    ForEach(vm.numbers, id: \.self) { number in
                        Text("\(number)")
                    }
                }
            }
        }.onAppear() {
            vm.fetch()
        }
    }
}

final class MinExampleViewModel: ObservableObject {

    @Published var numbers: [Int] = []
    @Published var names: [String] = []
    @Published var minNumber: Int = 0
    @Published var minName: String = ""

    func fetch() {
        let dataInNumbers: [Int] = [1, 2, 3, 4, 5]
        let dataInNames: [String] = ["Aardvark", "Zebra", "Elephant"]
        numbers = dataInNumbers
        names = dataInNames
        dataInNumbers.publisher
            .min()
            .assign(to: &$minNumber)
        dataInNames.publisher
            .min()
            .assign(to: &$minName)
    }
}


#Preview {
    MinExampleView()
}

