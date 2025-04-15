//
//  MaxExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/26/1404 AP.
//

import SwiftUI
import Combine

struct MaxExample: View {

    @StateObject var vm = MaxExampleViewModel()

    var body: some View {
        VStack {
            List {
                Section(footer: Text("Max is \(vm.maxString)")) {
                    ForEach(vm.stringList, id: \.self) {
                        Text($0)
                    }
                }
            }
            List {
                Section(footer: Text("Max is \(vm.maxNumber)")) {
                    ForEach(vm.numbersList, id: \.self) {
                        Text("\($0)")
                    }
                }
            }
        }.onAppear {
            vm.fetch()
        }
    }
}

final class MaxExampleViewModel: ObservableObject {

    @Published var maxNumber: Int = 0
    @Published var maxString: String = ""
    @Published var stringList: [String] = []
    @Published var numbersList: [Int] = []

    func fetch() {
        let dataInStrings = ["Aardvark", "Zebra", "Elephant"]
        stringList = dataInStrings
        dataInStrings.publisher
            .max(by: compare(lhs:rhs:))
            .assign(to: &$maxString)
        let dataInNumbers = [900, 245, 783]
        numbersList = dataInNumbers
        dataInNumbers.publisher
            .max()
            .assign(to: &$maxNumber)
    }

    func compare(lhs: String, rhs: String) -> Bool {
        return lhs > rhs
    }
}

#Preview {
    MaxExample()
}
