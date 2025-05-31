//
//  RemoveDuplicatesExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct RemoveDuplicatesExample: View {
    @StateObject var vm = RemoveDuplicatesExampleViewModel()
    var body: some View {
        VStack {
            Button("Fetch") {
                vm.fetch()
            }
            List {
                ForEach(vm.people) { person in
                    Text(person.name)
                }
            }
        }
    }
}

final class RemoveDuplicatesExampleViewModel: ObservableObject {

    struct Person: Identifiable, Equatable {

        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
        }

        var name: String
        var id: Int
    }

    @Published var people: [Person] = []
    var cancellable: AnyCancellable?

    func fetch() {
        people = []
        let peopleIn: [Person] = [
            Person(name: "Alice", id: 1),
            Person(name: "Alice", id: 1),
            Person(name: "Bob", id: 2),
            Person(name: "Bob", id: 2),
            Person(name: "Charlie", id: 3),
        ]

       cancellable = peopleIn.publisher
            .removeDuplicates()
            .sink { [unowned self] person in
                people.append(person)
            }
    }

}

#Preview {
    RemoveDuplicatesExample()
}
