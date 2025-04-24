//
//  DropFirstExample.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 2/2/1404 AP.
//

import SwiftUI
import Combine

struct DropFirstExample: View {

    @StateObject var vm = DropFirstExampleViewModel()
    var borderColor: Color {
        switch vm.status {
        case .ok: .green
        case .invalid: .red
        default: .secondary
        }
    }
    var body: some View {
        VStack {
            TextField("user id", text: $vm.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(borderColor)
        }.padding()
    }
}

final class DropFirstExampleViewModel: ObservableObject {


    enum Validation {
        case ok, invalid, notEvaluated
    }

    @Published var text: String = ""
    @Published var status: Validation = .notEvaluated

    init() {
        $text
            .dropFirst()
            .map { text -> Validation in
                print("TEXT => \(text)")
                return text.count > 8 ? .ok : .invalid
            }.assign(to: &$status)
    }
}

#Preview {
    DropFirstExample()
}
