//
//  MapExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct MapExampleView: View {
    @StateObject var vm = MapExampleViewModel()

    var body: some View {
        VStack {
            HStack {
                TextField("Enter the card id", text: $vm.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Image(systemName: vm.isValid ? "checkmark.circle" : "xmark.circle")
            }
        }.padding()
    }
}

final class MapExampleViewModel: ObservableObject {

    @Published var text = ""
    @Published var isValid: Bool = false
    var cancellable: AnyCancellable?

    init() {
       cancellable = $text.map { text -> Bool in
           guard !text.isEmpty else { return false }
            return text.count == 16
        }.sink { isValid in
            self.isValid = isValid
        }
    }
}

struct MapKeyPathExample: View {
    @StateObject var vm = MapKeyPathExampleViewModel()
    var body: some View {
        VStack {
            Button("Fetch") {
                vm.fetch()
            }
            List {
                ForEach(vm.dataToView, id: \.self) { name in
                    Text(name)
                }
            }
        }
    }
}

final class MapKeyPathExampleViewModel: ObservableObject {

    struct Creator: Identifiable {
        var id = UUID()
        var fullName: String
    }
    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn = [
            Creator(fullName: "Mark Moeykens"),
            Creator(fullName: "Chris Ching"),
            Creator(fullName: "Paul Hudson"),
            Creator(fullName: "Joe Heck")
        ]
       cancellable = dataIn.publisher
            .map({$0.fullName})
            .sink { fullName in
                self.dataToView.append(fullName)
            }
    }
}

#Preview {
    MapKeyPathExample()
}
