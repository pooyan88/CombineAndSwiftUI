//
//  DropUntilOutputFromExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/2/1404 AP.
//

import SwiftUI
import Combine

struct DropUntilOutputFromExample: View {
    @StateObject var vm = DropUntilOutputFromExampleViewModel()
    var body: some View {
        VStack {
            Button("Start Pipeline") {
                vm.fetch()
                vm.startPipeline.send(true)
            }
            List {
                ForEach(vm.data, id: \.self) { text in
                    Text(text)
                }
            }
            Button("Stop Pipeline") {
                vm.cancellables.removeAll()
            }
        }
    }
}


final class DropUntilOutputFromExampleViewModel: ObservableObject {

    @Published var data: [String] = []
    @Published var startPipeline = PassthroughSubject<Bool, Never>()
    var formatter = DateFormatter()
    var cancellables: Set<AnyCancellable> = []

    func fetch() {
        formatter.dateFormat = "HH:mm:ss"

        Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .handleEvents(receiveOutput: { value in
                // This prints EVERYTHING — even before the drop
                print("👀 Emitted value (before drop):", self.formatter.string(from: value))
            })
            .drop(untilOutputFrom: startPipeline)
            .sink { completion in
                print("Completion ===> \(completion)")
            } receiveValue: { timer in
                let timeString = self.formatter.string(from: timer)
                print("✅ Received (after drop):", timeString)
                self.data.append(timeString)
            }
            .store(in: &cancellables)
    }
}


#Preview {
    DropUntilOutputFromExample()
}
