//
//  ContentView.swift
//  game02
//
//  Created by wjn on 2026/5/18.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        GameView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
