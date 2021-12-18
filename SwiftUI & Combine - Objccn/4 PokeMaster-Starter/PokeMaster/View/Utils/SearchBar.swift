//
//  SearchBar.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/18.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import Combine

// https://www.appcoda.com/swiftui-search-bar/
struct SearchBar: View {
    @Binding var text: String

    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .animation(.default)

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {

    @State static var text = "搜索"
    @State static var emptyText = ""

    static var previews: some View {
        SearchBar(text: $text)
        SearchBar(text: $emptyText)
    }
}
