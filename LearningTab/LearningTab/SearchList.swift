//
//  SearchList.swift
//  LearningTab
//
//  Created by Durgesh on 10/29/22.
//

import SwiftUI

struct Message: Identifiable, Codable {
    let id: Int
    var user: String
    var text: String
}

enum SearchScope: String, CaseIterable {
    case inbox, favorites
}

import SwiftUI

@available(iOS 15.0, *)
struct SearchList: View {
    @State var items: [NoteItem] = [] // State Variable
    
    //let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { item in
                    Text(item.text)
                }
                
            }
            .onAppear { // Whenever screen is launched; copy form UserDefaultManager to items
                items = UserDefaultManager.shared.getNotesList()
            }
            .navigationTitle("TESTING")
            .searchable(text: $searchText) {
                ForEach(searchResults) { result in
                    Text("Looking for: \(result.text)?").searchCompletion(result)
                }
            }
            .autocapitalization(.none)

        } // NavigationView
    } // body

    var searchResults: [NoteItem] { // Even this recalculates its value
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.text.lowercased().contains(searchText.lowercased())}
        }
    }
}
