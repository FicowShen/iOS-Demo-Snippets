//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/18.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {

    var body: some View {
        NavigationView {
            PokemonList().navigationBarTitle("宝可梦列表")
        }
    }
}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
