//
//  MinByExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/2/1404 AP.
//

import SwiftUI
import Combine

struct MinByExample: View {
    @StateObject var vm = MinByExampleViewModel()
    var body: some View {
            VStack {
                List {
                    ForEach(vm.dataToView) { profile in
                        HStack {
                            Text(profile.name)
                            Spacer()
                            Text(profile.city)
                        }
                    }
                }.listStyle(PlainListStyle())
                Text("Min City Name: \(vm.minValue)")
        }.onAppear {
            vm.fetch()
        }
    }
}

final class MinByExampleViewModel: ObservableObject {

    @Published var dataToView: [Profile] = []
    @Published var minValue: String = ""
    var cancellable: AnyCancellable?

    func fetch() {
        let dataIn = [Profile(name: "Igor", city: "Moscow"),
        Profile(name: "Rebecca", city: "Atlanta"),
        Profile(name: "Christina", city: "Stuttgart"),
        Profile(name: "Lorenzo", city: "Rome"),
        Profile(name: "Oliver", city: "London")]
        dataToView = dataIn
      cancellable = dataIn.publisher
            .min { currentProfile, nextProfile in  //shorthand argument : $0.city < $1.city
                return currentProfile.city < nextProfile.city
            }.sink { profile in
                self.minValue = profile.city
            }
    }
}

#Preview {
    MinByExample()
}
