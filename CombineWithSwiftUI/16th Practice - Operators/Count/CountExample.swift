//
//  CountExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 4/14/25.
//

import SwiftUI
import Combine

struct CountExample: View {
    
    @StateObject private var vm = CountExampleViewModel()
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                ListShower(data: vm.dataToView)
            } label: {
                HStack {
                    Text(vm.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.gray)
                    Text(vm.count.description)
                        .foregroundColor(Color.gray)
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray)
                }.padding()
                    .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                }
            }
                .padding()
                .onAppear {
                vm.fetch()
            }

        }
    }
}

final class CountExampleViewModel: ObservableObject {
    
    @Published var dataToView: [String] = []
    @Published var count = 0
    @Published var title = ""
    
    func fetch() {
        title = "Major Rivers"
        let dataIn = ["Nile", "Amazon", "Yangtze", "Mississippi", "Danube", "Ganges", "Volga", "Mekong"]
        dataToView = dataIn
        dataIn.publisher
            .count()
            .assign(to: &$count)
    }
}

public struct ListShower: View {
    
    @State var data: [String] = []
    
    public var body: some View {
        List(data, id: \.self) { item in
            Text(item)
        }
    }
}

#Preview {
    CountExample()
}
