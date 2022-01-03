//
//  PokemonInfoPanelHeader.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/10.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension PokemonInfoPanel {
    struct Header: View {

        let model: PokemonViewModel

        var body: some View {
            ZStack(alignment: .select) {
                pokemonIcon
                    .alignmentGuide(.horizontalSelect) { d in
                        d[HorizontalAlignment.leading] + 15
                    }
                    .alignmentGuide(.verticalSelect) { d in
                        d[VerticalAlignment.bottom] + d.height / 3 * 2
                    }
                HStack {
                    nameSpecies
                    verticalDivider
                        .padding([.leading, .trailing], 20)
                    VStack(spacing: 12) {
                        bodyStatus
                        typeInfo
                    }
                }
                .alignmentGuide(.horizontalSelect) { d in
                    d[HorizontalAlignment.leading]
                }
                .alignmentGuide(.verticalSelect) { d in
                    d[VerticalAlignment.center]
                }
            }
//            HStack(alignment: .verticalSelect, spacing: 18) {
//                pokemonIcon
//                    .alignmentGuide(.verticalSelect) { d in
//                        d[VerticalAlignment.bottom]
//                    }
//                nameSpecies
//                verticalDivider
//                VStack(spacing: 12) {
//                    bodyStatus
//                    typeInfo
//                }
//            }
        }

        var pokemonIcon: some View {
            KFImage(model.iconImageURL)
                .resizable()
                .frame(width: 68, height: 68)
        }

        var nameSpecies: some View {
            VStack(alignment: .horizontalSelect, spacing: 10) {
                VStack(alignment: .horizontalSelect) {
                    Text(model.name)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(model.color)
                    Text(model.nameEN)
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(model.color)
                        .alignmentGuide(.horizontalSelect) { d in
                            d[HorizontalAlignment.leading]
                        }
                }
                .alignmentGuide(.horizontalSelect) { d in
                    d[HorizontalAlignment.trailing]
                }
                Text(model.genus)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .alignmentGuide(.horizontalSelect) { d in
                        d[HorizontalAlignment.trailing]
                    }
            }
        }

        var verticalDivider: some View {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 1, height: 44)
                .opacity(0.1)
        }

        var bodyStatus: some View {
            VStack(alignment: .leading) {
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
                ForEach(self.model.types) { t in
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(t.color)
                            .frame(width: 36, height: 14)
                        Text(t.name)
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct PokemonInfoPanelHeader_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel.Header(model: .sample(id: 2))
    }
}
#endif
