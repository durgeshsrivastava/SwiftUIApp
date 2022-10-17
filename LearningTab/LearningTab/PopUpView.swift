//
//  PopUpView.swift
//  LearningTab
//
//  Created by Durgesh on 10/8/22.
//

import SwiftUI

let dateFormatter = DateFormatter()

class NoteItem1: ObservableObject {
    
}

class NoteItem: ObservableObject{
    internal init(id: Int, text: String, date: Date = Date()) {
        self.id = id
        self.text = text
        self.date = date
    }
    
    let id: Int
     let text: String
    var date = Date()
    var dateText: String {
        dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
        return dateFormatter.string(from: date)
    }
} // struct NoteItem

struct PopUpView: View {
    @Binding var message: String
    /// The document that the environment stores.
    @EnvironmentObject var document: ChecklistDocument
    /// The undo manager that the environment stores.
    /// - Tag: UndoManager
    @Environment(\.undoManager) var undoManager
    
    #if os(iOS) // Edit mode doesn't exist in macOS.
    @Environment(\.editMode) var editMode
    #endif // os(iOS)
    
    /// The internal selection state.
    @State private var selection = Set<UUID>()
    
    @StateObject var items: [NoteItem] = {
        guard let data = UserDefaults.standard.data(forKey: "notes") else { return [] }
        if let json = try? JSONDecoder().decode([NoteItem].self, from: data) {
            return json
        }
        return []
    }()
    

    
    @State var taskText: String = ""
    
    @State var showAlert = false
    
    @State var itemToDelete: NoteItem?
    
    var alert: Alert {
        Alert(title: Text("Hey!"),
              message: Text("Are you sure you want to delete this item?"),
              primaryButton: .destructive(Text("Delete"), action: nil),
              secondaryButton: .cancel())
    }
    
//    var inputView: some View {
//        HStack {
//            TextField("Write a note ...", text: $taskText)
//                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
//                .clipped()
//            Button(action: didTapAddTask, label: { Text("Add") }).padding(8)
//        }
//    }
    
    var body: some View {
        VStack { // Copied from a notepad program on gitHub
            //inputView
            Divider()
            List(items) { item in
                VStack(alignment: .leading) {
                    Text(item.text)
                        .font(.headline)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    Text(item.dateText)
                        .font(.subheadline)
                    Text(items.debugDescription)
                }
                .onLongPressGesture {
                    self.itemToDelete = item
                    self.showAlert = true
                }
            }
            .alert(isPresented: $showAlert, content: {
                alert
            })
        } // VStack
        .padding(20)
        .navigationBarTitle(Text("Appreciate Yourself"))
    } // body
        
    mutating func didTapAddTask() {
            let id = items.reduce(0) { max($0, $1.id) } + 1
            items.insert(NoteItem(id: id, text: taskText), at: 0)
            taskText = ""
            print("didTapAddTask: saving")
            save()
        }
        
    mutating func deleteNote() {
            guard let itemToDelete = itemToDelete else { return }
        items = items.filter { $0.id != itemToDelete.id }
            save()
        }
        
        func save() {
            guard let data = try? JSONEncoder().encode(items) else { return }
            UserDefaults.standard.set(data, forKey: "notes")
            print(items)
        }
        
//        VStack {
//                List(selection: $selection) {
//                    // Iterate over a collection of bindings to the items.
//                    ForEach($document.checklist.items) { $item in
//                        ChecklistRow(item: $item) {
//                            // The checkbox toggle action.
//                            document.toggleItem($item.wrappedValue, undoManager: undoManager)
//                        } onTextCommit: { oldTitle in
//                            // The title changed the commit action.
//                            document.registerUndoTitleChange(for: $item.wrappedValue, oldTitle: oldTitle, undoManager: undoManager)
//                        }
//                    }
//                    .onDelete(perform: onDelete)
//                    .onMove(perform: onMove)
//                } // List
//
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        addButton
//                            .disabled(editMode?.wrappedValue == .active ? true : false)
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                    }
//                }
//
//                Button("save") {
//                    UserDefaultManager.shared.saveNotes(key: "Durgesh", checklist: document.checklist) { Success in
//                        print("Sucess:\(Success)")
//                    }
//                }
//        } //VStack
//        .padding(20)
//        .navigationBarTitle(Text("Appreciate Yourself"))
        
//    } // body
    /// Adds a new item to the list.
    var addButton: some View {
        Button(action: {
            print("Button tapped!")
            withAnimation {
                document.addItem(title: "Another item.", undoManager: undoManager)
            }
        }) {
            Image(systemName: "plus")
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    /// A button with an action that deletes the selected items from the list.
    var deleteButton: some View {
        Button(action: {
            print("Button tapped!")
            withAnimation {
                document.deleteItems(withIDs: Array(selection), undoManager: undoManager)
            }
            selection.removeAll()
        }) {
            Image(systemName: "trash")
        }
        .buttonStyle(BorderlessButtonStyle())
        .disabled(selection.isEmpty)
    }
    
    /// Deletes a set of items from the list.
    func onDelete(offsets: IndexSet) {
        document.delete(offsets: offsets, undoManager: undoManager)
    }
    
    /// Moves a set of items to a new location.
    func onMove(offsets: IndexSet, toOffset: Int) {
        document.moveItemsAt(offsets: offsets, toOffset: toOffset, undoManager: undoManager)
    }
    
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(message: .constant("PopUPLearning"))
    }
}
