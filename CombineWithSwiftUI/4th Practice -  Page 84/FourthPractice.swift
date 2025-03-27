//
//  FourthPractice.swift
//  CombineWithSwiftUI
//
//  Created by Pooyan J on 1/2/1404 AP.
//

import SwiftUI
import Combine

struct FourthPractice: View {

    @StateObject var viewModel = FourthPracticeViewModel()

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            TextEditor(text: $viewModel.text)
                .border(Color.gray)
                .frame(width: 350, height: 200)
                .cornerRadius(10)
            Text("\(viewModel.text.count) / \(viewModel.textLimit.description) ")
                .foregroundColor(viewModel.countColor)
        }
    }
}

final class FourthPracticeViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var textCount = 0
    @Published var countColor: Color = .blue
    var textLimit = 50

    init() {
        $text
            .map { text in
                return text.count
            }.assign(to: &$textCount)
        $textCount
            .map { [unowned self] count -> Color  in
                getCountColor(textCount: count)
            }.assign(to: &$countColor)
    }

    private func getCountColor(textCount: Int) -> Color {
        let eightyPercent = Double(textLimit) * 0.8
        if (Int(eightyPercent)...textLimit).contains(textCount) {
            return .yellow
        } else if textCount > textLimit {
            return .red
        }
        return .gray
    }
}

#Preview {
    FourthPractice()
}
