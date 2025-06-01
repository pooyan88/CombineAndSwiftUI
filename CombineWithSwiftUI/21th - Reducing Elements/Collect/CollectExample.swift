//
//  CollectExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/11/1404 AP.
//

import SwiftUI
import Combine

struct CollectExample: View {
    @StateObject var vm = CollectExampleViewModel()
    var body: some View {
        VStack {
            Toggle("Make them Circle", isOn: $vm.isCircle)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(vm.dataToView, id: \.self) { item in
                    Image(systemName: item)
                }
            }
        }.onAppear {
            vm.fetch()
        }.padding()
    }
}

final class CollectExampleViewModel: ObservableObject {

    @Published var isCircle: Bool = false
    @Published var dataToView: [String] = []
    var staticInts: [Int] = []
    var cancellable: AnyCancellable?

    init() {
        staticInts = Array(1...25)
    }

    func fetch() {
        cancellable =  $isCircle
          .sink { [unowned self] shape in formatData(shape: shape ? "circle" : "square") }
    }

    func formatData(shape: String) {
        staticInts.publisher
        .map { "\($0).\(shape)" }
        .collect()
        .assign(to: &$dataToView)
    }
}

struct CollectExample2: View {
    @StateObject var vm = CollectExampleViewModel2()
    var body: some View {
        VStack {
            List {
                ForEach(vm.dataToView, id: \.self) { item in
                    Text(item)
                }
            }
        }.onAppear {
            vm.fetch()
        }
    }
}

final class CollectExampleViewModel2: ObservableObject {

    struct Person {
        var name: String
        var age: Int
    }

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [Person] = [
            Person(name: "Ali", age: 20),
            Person(name: "Hamid", age: 20),
            Person(name: "Reza", age: 20),
        ]
        dataIn.publisher
            .map { person in
                return person.name
            }.prepend("k")
            .collect()
            .assign(to: &$dataToView)
    }
}

#Preview {
    CollectExample2()
}
