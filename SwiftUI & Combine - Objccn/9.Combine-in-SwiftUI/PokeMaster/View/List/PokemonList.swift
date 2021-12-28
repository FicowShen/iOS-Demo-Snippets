//
//  PokemonList.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/30.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @EnvironmentObject var store: Store

    private var expandingIndex: Int? {
        store.appState.pokemonList.operation.expandingIndex
    }

    var body: some View {
        ScrollView {
            TextField("搜索", text: $store.appState.pokemonList.operation.searchText)
                .frame(height: 40)
                .padding(.horizontal, 25)
            ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: expandingIndex == pokemon.id
                )
                .onTapGesture {
                    withAnimation(
                        .spring(
                            response: 0.55,
                            dampingFraction: 0.425,
                            blendDuration: 0
                        )
                    )
                    {
                        store.dispatch(
                            .toggleListSelection(index: pokemon.id)
                        )
                    }
                }
            }
        }
//        .overlay(
//            VStack {
//                Spacer()
//                PokemonInfoPanel(model: .sample(id: 1))
//            }.edgesIgnoringSafeArea(.bottom)
//        )
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}
