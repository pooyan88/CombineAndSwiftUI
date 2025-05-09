//
//  PrefixUntilOutputFromExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/10/1404 AP.
//

import SwiftUI
import Combine

struct PrefixUntilOutputFromExample: View {
    @StateObject var vm = PrefixUntilOutputViewModel()
    var body: some View {
        VStack {
            Button("Start pipeline") {
                vm.cutPipeline.send(true)
                vm.fetch()
            }
            List {
                ForEach(vm.dataToView, id: \.self) { text in
                    Text(text)
                }
            }
            Button("Stop pipeline") {
                vm.cutPipeline.send(false)
            }
        }
    }
}

final class PrefixUntilOutputViewModel: ObservableObject {

    @Published var dataToView: [String] = []
    var cutPipeline = PassthroughSubject<Bool, Never>()
    var cancellable: AnyCancellable?

    func fetch() {
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .prefix(untilOutputFrom: cutPipeline)
            .sink(receiveValue: { [unowned self] time in
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                dataToView.append(formatter.string(from: time))
            })
    }
}

#Preview {
    PrefixUntilOutputFromExample()
}
