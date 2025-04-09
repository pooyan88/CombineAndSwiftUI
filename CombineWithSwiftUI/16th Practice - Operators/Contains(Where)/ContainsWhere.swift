//
//  ContainsWhere.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/20/1404 AP.
//

import SwiftUI
import Combine

struct ContainsWhere: View {

    @StateObject private var vm = ContainsWhereViewModel()

    var body: some View {
        VStack {
            Text(vm.fruitName?.name ?? "")
            Toggle("Vitamin A", isOn: $vm.vitaminA)
            Toggle("Vitamin B", isOn: $vm.vitaminB)
            Toggle("Vitamin C", isOn: $vm.vitaminC)
        }
        .padding()
        .onAppear {
            vm.fetch()
        }
    }
}

final class ContainsWhereViewModel: ObservableObject {

    enum VitaminType {
        case vitaminA, vitaminB, vitaminC
    }

    struct Fruit {
        var name: String
        var addtionalData: String
    }

    @Published var fruitName: Fruit?
    @Published var vitaminA: Bool = false
    @Published var vitaminB: Bool = false
    @Published var vitaminC: Bool = false
    var cancellable: AnyCancellable?

    func fetch() {
        var dataInMemory: [Fruit] = []
        dataInMemory.append(.init(name: "Apple", addtionalData: "Vitamin A, Vitamin C"))
        cancellable = dataInMemory.publisher
            .sink { fruit in
                self.fruitName = fruit
            }
        dataInMemory.publisher
            .contains { fruit in
                return fruit.addtionalData.contains("Vitamin A")
            }.assign(to: &$vitaminA)
        dataInMemory.publisher
            .contains { fruit in
                return fruit.addtionalData.contains("Vitamin B")
            }.assign(to: &$vitaminB)
        dataInMemory.publisher
            .contains { fruit in
                return fruit.addtionalData.contains("Vitamin C")
            }.assign(to: &$vitaminC)
    }
}


#Preview {
    ContainsWhere()
}
