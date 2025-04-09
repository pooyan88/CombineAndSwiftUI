//
//  TryContainsWhere.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/20/1404 AP.
//

import SwiftUI
import Combine

struct TryContainsWhere: View {

    @StateObject var vm = TryContainsWhereViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Look for salt stone")
            Picker("Place", selection: $vm.place) {
                Text("Nevada").tag("Nevada")
                Text("Utah").tag("Utah")
                Text("Mars").tag("Mars")
            }.pickerStyle(SegmentedPickerStyle())
            Button("Search") {
                vm.search()
            }
            .alert(item: $vm.invalidSelectError) { error in
                Alert(title: Text("Error"), message: Text("Invalid Selection"))
            }
            Text("Result \(vm.result)")
        }.padding()
    }
}

final class TryContainsWhereViewModel: ObservableObject {

    struct InvalidSelectionError: Error, Identifiable {
        var id = UUID()
    }

    @Published var place: String = "Nevada"
    @Published var result: String = ""
    @Published var invalidSelectError: InvalidSelectionError?

    func search() {
        let incomingData = ["Places with Salt Water", "Utah", "California"]
      _ = incomingData.publisher
            .tryContains { item in
                if place == "Mars" {
                    throw InvalidSelectionError()
                }
                return place == item
            }
            .sink { completion in
                if case .failure(let error) = completion {
                    self.invalidSelectError = error as? InvalidSelectionError
                }
            } receiveValue: { [unowned self] isFound in
                result = isFound ? "Found" : "Not found"
            }


    }
}

#Preview {
    TryContainsWhere()
}
