//
//  EighthPractice.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/3/1404 AP.
//

import SwiftUI
import Combine

struct EighthPractice: View {

    @StateObject private var viewModel = EighthPracticeViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Button("Say Hello") {
                viewModel.sayHello()
            }
            Text(viewModel.hello)
            Button("Say Goodbye") {
                viewModel.sayGoodbye()
            }
            Text(viewModel.goodbye)
        }
    }
}

final class EighthPracticeViewModel: ObservableObject {
    @Published var hello = ""
    @Published var goodbye = ""

    var cancellable: AnyCancellable?

    func sayHello() {
        _ = Future<String, Never> { [unowned self] promise in
              self.hello = "Hello"
          }
    }

    func sayGoodbye() {
        cancellable = Future<String, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                promise(.success("Goodbye"))
            }
        }.sink { [unowned self] value in
            self.goodbye = value
        }
    }
}

struct FutureOnlyRunsOnceView: View {

    @StateObject private var viewModel = FutureOnlyRunsOnceViewModel()

    var body: some View {
        VStack {

            Text(viewModel.initialText)

            Button("another assign Below") {
                viewModel.assignToSecond()
            }
            Text(viewModel.secondText)
        }
        .onAppear {
            viewModel.assignToFirst()
        }
    }
}

final class FutureOnlyRunsOnceViewModel: ObservableObject {

    @Published var initialText = ""
    @Published var secondText = ""

    let futurePublisher = Future<String, Never> { promise in
        promise(Result.success("Initial Text"))
        print("The Future Publisher only publish Once")
    }

    func assignToFirst() {
        futurePublisher.assign(to: &$initialText)
    }

    func assignToSecond() {
        futurePublisher.assign(to: &$secondText)
    }
}

struct FutureRunMultipleTimesView: View {

    @StateObject private var viewModel = FutureRunMultipleTimesViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.initialText)
            Button("Assign Multiple Times") {
                viewModel.runAgain()
            }
            Text(viewModel.secondText)
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

final class FutureRunMultipleTimesViewModel: ObservableObject {

    @Published var initialText = ""
    @Published var secondText = ""

    var futurePublisher = Deferred { Future<String, Never> { promise in
        promise(Result.success("Initial Text"))
        print("The Future Publisher run Multiple Times")
    }
}

    func fetch() {
        futurePublisher
            .assign(to: &$initialText)
    }

    func runAgain() {
        futurePublisher
            .assign(to: &$secondText)
    }

}

#Preview {
    FutureRunMultipleTimesView()
}
