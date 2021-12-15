//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/15.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {

    let model: PokemonViewModel

    var abilities: [AbilityViewModel] { AbilityViewModel.sample(pokemonID: model.id)
    }

    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }

    var body: some View {
        VStack(spacing: 20) {
            topIndicator
            Header(model: model)
        }
    }
}

extension PokemonInfoPanel {
    struct Header: View {
        let model: PokemonViewModel

        var body: some View {
            HStack(spacing: 18) {
                pokemonIcon
                nameSpecies
                verticalDivider
                VStack(spacing: 12) {
                    bodyStatus
                    typeInfo
                }
            }
        }

        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68)
        }

        var nameSpecies: some View {
            VStack {
                Text(model.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(model.color)
                Text(model.nameEN)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(model.color)
                Text(model.genus)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            .padding(0)
        }

        var verticalDivider: some View {
            Rectangle()
                .frame(width: 1, height: 44)
                .foregroundColor(Color(hex: 0, alpha: 0.1))
        }

        var bodyStatus: some View {
            VStack {
                HStack {
                    Text("身高")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.height)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
                HStack {
                    Text("体重")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.weight)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
            }
        }

        var typeInfo: some View {
            HStack {
                ForEach(model.types) { type in
                    Text(type.name)
                        .font(.system(size: 11))
                        .frame(width: 36, height: 14)
                        .foregroundColor(.white)
                        .background(type.color)
                        .cornerRadius(7)
                }
            }
        }
    }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: .sample(id: 1))
    }
}
