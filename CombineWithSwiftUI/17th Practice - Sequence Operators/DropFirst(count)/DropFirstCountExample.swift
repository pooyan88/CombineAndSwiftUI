//
//  DropFirstCountExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/2/1404 AP.
//

import SwiftUI
import Combine

struct DropFirstCountExample: View {
    @StateObject var vm = DropFirstCountExampleViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(vm.dataToView, id: \.self) { text in
                    Text(text)
                }
            }
        }.onAppear {
            vm.fetch()
        }
    }
}

final class DropFirstCountExampleViewModel: ObservableObject {

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn: [String] = ["1", "2", "3", "4", "5"]
      cancellable = dataIn.publisher
            .dropFirst(2)
            .sink { value in
                self.dataToView.append(value)
            }
    }
}

#Preview {
    DropFirstCountExample()
}
