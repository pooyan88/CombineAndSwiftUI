//
//  PrependExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/19/1404 AP.
//

import SwiftUI
import Combine

struct PrependExample: View {
    @StateObject private var viewModel = PrependExampleViewModel()
    var body: some View {
        List {
            ForEach(viewModel.dataToView, id: \.self) { text in
                Text(text)
            }
        }
    }
}

final class PrependExampleViewModel: ObservableObject {

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    init() {
        let combineAuthors: [String] = ["Karin", "Donny", "Shai", "Daniel", "Mark"]
        cancellable = combineAuthors.publisher
            .prepend("COMBINE AUTHORS")
            .prepend("This Item Comes First <-")
            .sink { [unowned self] author in
                dataToView.append(author)
            }
    }
}

struct PrependExample2: View {
    @StateObject private var viewModel = PrependExampleMultipleCase()
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.dataToView, id: \.self) { text in
                    Text(text)
                        .fontWeight((text == "READ" || text == "UNREAD") ? .bold : .regular)
                }
            }
        }.onAppear {
            viewModel.fetch()
        }
    }
}

final class PrependExampleMultipleCase: ObservableObject {

    @Published var dataToView: [String] = []
    var cancellable: AnyCancellable?

    func fetch() {
        let unreadMessages = ["unreadMessage1", "unreadMessage2", "unreadMessage3"]
            .publisher
            .prepend("UNREAD")

        let readMessages = ["readMessage1", "readMessage2", "readMessage3"]
            .publisher
            .prepend("READ")

       cancellable = readMessages
            .prepend(unreadMessages)
            .sink { [unowned self] message in
                dataToView.append(message)
            }
    }
}

#Preview {
    PrependExample2()
}
