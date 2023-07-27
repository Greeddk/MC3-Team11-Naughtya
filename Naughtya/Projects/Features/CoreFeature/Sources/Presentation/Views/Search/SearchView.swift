//
//  SearchView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct SearchView: View {
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()

    @StateObject private var viewModel = SearchViewModel()
    private let textFieldHeight: CGFloat = 40

    public var body: some View {
        TextField(text: $viewModel.searchedText) {
            Text("오늘 할 일을 검색해보세요.")
                .font(Font.custom("Apple SD Gothic Neo", size: 12))
                .foregroundColor(Color.customGray1)
        }
        .textFieldStyle(.roundedBorder)
        .padding(.horizontal)
        .frame(height: textFieldHeight)
        .onChange(of: viewModel.searchedText) {
            viewModel.searchGlobally(text: $0)
        }
        .onExitCommand {
            viewModel.searchedText = ""
        }
    }

    private var searchedTodoList: some View {
        ScrollView {
            TodoListView(todos: viewModel.searchedTodos)
                .padding()
        }
        .frame(height: 256)
        .background(.white)
        .border(.gray)
        .offset(y: textFieldHeight)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
