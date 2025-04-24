//
//  TryMaxBy.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/26/1404 AP.
//

import SwiftUI
import Combine

struct TryMaxByExample: View {
    @StateObject var vm = TryMaxByViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(vm.numbers, id: \.self) { num in
                    Text("\(num)")
                }
            }
            Text("Max Number: \(vm.maxNumber)")
        }
        .alert("Error", isPresented: $vm.isAlertRequired, actions: {
            Button(role: .cancel) {
                print("cancel")
            } label: {
                Text("OK")
            }


        }, message: {
            if let message = vm.inputError?.message {
                Text("\(message)")
            }
        })
        .onAppear {
            vm.fetch()
        }
    }
}

final class TryMaxByViewModel: ObservableObject {

    struct InputError: Error, Identifiable {
        var id = UUID()
        var title: String
        var message: String
    }

    @Published var numbers: [Int] = []
    @Published var maxNumber: Int = 0
    @Published var inputError: InputError?
    @Published var isAlertRequired: Bool = false
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [Int] = [1, 2, 3, 4, 6, 7]
        numbers = dataIn
      cancellable =  dataIn.publisher
            .tryMax { current, next in
                if next < current {
                    throw InputError(title: "Error", message: "Max value is \(next)")
                }
                return current < next
            }.sink { completion in
                if case .failure(let error) = completion {
                    self.isAlertRequired = true
                    self.inputError = InputError(title: "Error", message: error.localizedDescription)
                }
            } receiveValue: { maxValue in
                self.maxNumber = maxValue
            }
    }
}

#Preview {
    TryMaxByExample()
}
