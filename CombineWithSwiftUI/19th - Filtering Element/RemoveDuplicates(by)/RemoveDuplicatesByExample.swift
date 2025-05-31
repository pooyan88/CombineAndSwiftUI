//
//  RemoveDuplicatesByExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 3/10/1404 AP.
//

import SwiftUI
import Combine

struct RemoveDuplicatesByExample: View {
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

final class RemoveDuplicatesByExampleViewModel: ObservableObject {
    struct Person: Identifiable {
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
            .removeDuplicates(by: { previousPerson, currentPerson in // <= this closure gives you previous and current item
                return previousPerson.id == currentPerson.id
            })
            .sink { [unowned self] person in
                people.append(person)
            }
    }
}

#Preview {
    RemoveDuplicatesByExample()
}
