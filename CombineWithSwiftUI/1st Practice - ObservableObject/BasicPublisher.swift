//
//  SwiftUI.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/24/1404 AP.
//

import SwiftUI
import Combine

struct PublisherAndObservable: View {
    @StateObject var vm = PublisherAndObservableViewModel() // <- this is the subscriber that receive notifications of changes
    @State var message = ""
     var body: some View {
        VStack {
            Text(vm.state)
            HStack {
                TextField("Text", text: $vm.state)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(Color.gray)
                Text(vm.message)
            }
        }
        .padding()
     }
}
final class PublisherAndObservableViewModel: ObservableObject { // <- this is the way view model notify the view for changes

    @Published var state: String = "First State"
    @Published var message: String = ""
    var cancellable: AnyCancellable?

    init() {
        valueDidUpdate()
    }

    func valueDidUpdate() {
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            state = "Second State"
            cancellable =  $state.map({$0})
                .sink { [unowned self] newValue in
                    message = newValue.isEmpty ? "❌" : "✅"
            }
        }
    }
}

#Preview {
    PublisherAndObservable()
}
