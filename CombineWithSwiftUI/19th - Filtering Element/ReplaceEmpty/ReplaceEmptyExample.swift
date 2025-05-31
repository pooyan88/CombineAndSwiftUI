//
//  ReplaceEmptyExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct ReplaceEmptyExample: View {
    @StateObject var vm = ReplaceEmptyExampleViewModel()
    var body: some View {
        VStack {
            HStack {
                TextField("Enter text", text: $vm.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Fetch") {
                    vm.fetch()
                }
            }.padding()
            List {
                ForEach(vm.items, id: \.self) { item in
                    Text(item)
                }
            }
        }
    }
}

final class ReplaceEmptyExampleViewModel: ObservableObject {

    @Published var items: [String] = []
    @Published var text: String = ""
    var cancellable: AnyCancellable?
    func fetch() {
        items = []
        let dataIn: [String] = ["Result1", "Result2", "Result3", "Result4"]
     cancellable =  dataIn.publisher
            .filter { item in
                return item.contains(text)
            }.replaceEmpty(with: "No data found")
            .sink { item in
                self.items.append(item)
            }
    }
}

#Preview {
    ReplaceEmptyExample()
}
