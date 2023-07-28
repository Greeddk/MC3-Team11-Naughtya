//
//  TodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct TodoListView: View {
    public let section: DragDropItemable?
    public let todos: [TodoModel]
    public let isBlockedToEdit: Bool
    public let dragDropDelegate: DragDropDelegate
    @State private var absoluteRect: CGRect!

    public init(
        section: DragDropItemable? = nil,
        todos: [TodoModel] = [],
        isBlockedToEdit: Bool = false,
        dragDropDelegate: DragDropDelegate = DragDropManager.shared
    ) {
        self.section = section
        self.todos = todos
        self.isBlockedToEdit = isBlockedToEdit
        self.dragDropDelegate = dragDropDelegate
    }

    public var body: some View {
        ZStack {
            if section != nil {
                GeometryReader { geometry in
                    let absoluteRect = geometry.frame(in: .global)
                    Color.black.opacity(0.01)
                        .onAppear {
                            registerAbsoluteRect(absoluteRect)
                        }
                        .onChange(of: absoluteRect) {
                            registerAbsoluteRect($0)
                        }
                }
            }
            VStack(spacing: 0) {
                if section is DailyTodoListEntity,
                   todos.isEmpty {
                    HStack(alignment: .center, spacing: 4) {
                        Text("데일리 투두에 오늘 할일을 드래그 해주세요")
                          .lineLimit(1)
                          .font(Font.custom("SF Pro", size: 16))

                          .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                          .frame(width: 277, height: 16, alignment: .center)
                          .padding(.vertical, 8)
                          .cornerRadius(5)
                          .overlay(
                            RoundedRectangle(cornerRadius: 5)
                              .inset(by: 0.5)
                              .stroke(Color(red: 0.31, green: 0.31, blue: 0.31), lineWidth: 1)
                              .frame(width: 600, height: 50)
                          )
                    }
                    .padding()
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                } else {
                    ForEach(todos) { todo in
                        TodoItemView(
                            todo: todo,
                            isBacklog: section is ProjectEntity,
                            isBlockedToEdit: isBlockedToEdit
                        )
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .onDisappear {
            unregisterAbsoluteRect()
        }
    }

    private var dragDropableHash: DragDropableHash? {
        guard let item = section else {
            return nil
        }
        return DragDropableHash(
            item: item,
            priority: 2
        )
    }

    private func registerAbsoluteRect(_ rect: CGRect) {
        guard let hash = dragDropableHash else {
            return
        }
        absoluteRect = rect
        dragDropDelegate.registerAbsoluteRect(
            hash,
            rect: rect
        )
    }

    private func unregisterAbsoluteRect() {
        guard let hash = dragDropableHash else {
            return
        }
        dragDropDelegate.unregisterAbsoluteRect(hash)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(
            section: ProjectEntity.sample,
            todos: []
        )
    }
}
