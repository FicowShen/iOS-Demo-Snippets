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

    @State var darkBlur = false

    var abilities: [AbilityViewModel] { AbilityViewModel.sample(pokemonID: model.id)
    }

    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }

    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true) // keeps showing multiline text
    }

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                self.darkBlur.toggle()
            }, label: {
                Text("切换模糊效果")
            })
            topIndicator
            Header(model: model)
            pokemonDescription
            Divider()
            AbilityList(
                model: model,
                abilityModels: abilities
            )
        }
        .padding(
            EdgeInsets(
                top: 12,
                leading: 30,
                bottom: 30,
                trailing: 30
            )
        )
        .blurBackground(style: darkBlur
                            ? .systemMaterialDark
                            : .systemMaterial)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}


struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: .sample(id: 1))
    }
}
