//
//  PokemonList.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/15.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {

    @State var expandingIndex: Int?

    var body: some View {
        // List cannot hide the separator lines
        // Replace it with ScrollView
//        List(PokemonViewModel.all) { pokemon in
//            PokemonInfoRow(model: pokemon, expanded: false)
//        }
        ScrollView {
            ForEach(PokemonViewModel.all) { pokemon in
                PokemonInfoRow(model: pokemon,
                               expanded: self.expandingIndex == pokemon.id)
                    .onTapGesture {
                        withAnimation(
                            .spring(
                                response: 0.55,
                                dampingFraction: 0.425,
                                blendDuration: 0
                            )
                        ) {
                            self.expandingIndex = (self.expandingIndex == pokemon.id ? nil : pokemon.id)
                        }
                    }
            }
        }
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}
