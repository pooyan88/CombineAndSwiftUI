//
//  TryScanExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/11/1404 AP.
//

import SwiftUI
import Combine

struct TryScanExample: View {
    @StateObject var vm = TryScanExampleViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(vm.dataToView, id: \.self) {
                    Text($0)
                }
            }
        }.alert(item: $vm.error) { error in
            Alert(title: Text(error.title), message: Text(error.description))
        }
    }
}

final class TryScanExampleViewModel: ObservableObject {

    struct MyError: Error, Identifiable, CustomStringConvertible {
        var id = UUID()
        var title = "Error"
        var description = "non-numeric found"
    }

    @Published var dataToView: [String] = []
    @Published var error: MyError?
    var cancellable: AnyCancellable?

    init() {
        let dataIn: [String] = ["1", "2", "3", "4", "A"]
      cancellable =  dataIn.publisher
            .tryScan("") { storedValues, currentValue in
                if let currentValueInt = Int(currentValue) {
                    return storedValues + " " + currentValue
                } else {
                    throw MyError()
                }
            }.sink { [unowned self] completion in
                if case .failure(let failure) = completion {
                    error = failure as? MyError
                }
            } receiveValue: { item in
                self.dataToView.append(item)
            }

    }
}

#Preview {
    TryScanExample()
}
