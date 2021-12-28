//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/02.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            if store.appState.pokemonList.pokemons == nil {
                switch store.appState.pokemonList.loadingStatus {
                case .toLoad, .loading, .loaded:
                    Text("Loading!...")
                        .onAppear {
                            self.store.dispatch(.loadPokemons)
                        }
                case .failed:
                    Button {
                        self.store.dispatch(.loadPokemons)
                    } label: { // new swift closure feature?
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Retry")
                        }
                        // add corner rounded border for button
                        // https://stackoverflow.com/questions/58928774/button-border-with-corner-radius-in-swift-ui
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    .foregroundColor(Color.gray)
                }
            } else {
                PokemonList().navigationBarTitle("宝可梦列表")
            }
        }
    }
}

struct PokemonListRoot_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
