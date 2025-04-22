//
//  AppendExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/2/1404 AP.
//

import SwiftUI
import Combine

struct AppendExampleView: View {

    @StateObject var vm = AppendExampleViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(vm.dataToView, id: \.self) { text in
                    Text(text)
                }
            }
            Button("Fetch") {
                vm.fetch()
            }
        }
    }
}


final class AppendExampleViewModel: ObservableObject {

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn = ["A", "B", "C"]
    cancellable = dataIn.publisher
            .append("E")
            .append("F") // items will append when pipeline finished, and all items published.
            .sink(receiveCompletion: { comple in
                print("COMPLETION ===> " ,comple)
            }, receiveValue: { [unowned self] character in
                dataToView.append(character)
            })
    }
}

struct AppendExampleView2: View {

    @StateObject var vm = AppendExampleViewModel2()
    var body: some View {
        VStack {
            List {
                ForEach(vm.dataToView, id: \.self) { text in
                    Text(text)
                }
            }
            Button("Fetch") {
                vm.fetch()
            }
        }
    }
}

final class AppendExampleViewModel2: ObservableObject {

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

     init() {
    cancellable = dataToView.publisher
            .append("E")
            .append("F") // items will append when pipeline finished, and all items published.
            .sink(receiveCompletion: { comple in
                print("COMPLETION ===> " ,comple)
            }, receiveValue: { character in
                print(character)
            })
    }

    func fetch() {
        _ = ["A", "B", "C"]
    }
}


struct AppendPipelinesExample: View {
    @StateObject var vm = AppendPipelinesExampleViewModel()
    var body: some View {
        VStack {
            List {
                ForEach(vm.dataToView, id: \.self) { text in
                    Text(text)
                        .fontWeight(text.contains("READ") ? .bold : .regular)

                }
            }
        }.onAppear {
            vm.fetch()
        }
    }
}

final class AppendPipelinesExampleViewModel: ObservableObject {

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        let read = ["Donny Wals Newsletter", "Dave Verwer Newsletter", "Paul Hudson Newsletter"]
        let unread = ["New from Meng", "What Shai Mishali says about Combine"]
            .publisher
            .prepend("UNREAD")

       cancellable = read.publisher
            .prepend("READ")
            .append(unread)
            .sink { [unowned self] data in
                dataToView.append(data)
            }
    }
}


#Preview {
    AppendPipelinesExample()
}
