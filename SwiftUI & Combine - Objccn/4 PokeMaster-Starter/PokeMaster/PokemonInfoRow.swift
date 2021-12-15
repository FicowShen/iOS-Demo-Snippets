//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/15.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonInfoRow: View {
//    let model = PokemonViewModel.sample(id: 1)

    let model: PokemonViewModel

    let expanded: Bool

    var body: some View {
        VStack {
            HStack {
                Image("Pokemon-\(model.id)")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 12)
            Spacer()
            HStack(spacing: CGFloat(expanded ? 20 : -30)) {
//            HStack(spacing: CGFloat(20)) {
                Spacer()
                Button(action: { print("fav") }) {
                    Image(systemName: "star")
                        .modifier(ToolButtonModifier())
//                        .font(.system(size: 25))
//                        .foregroundColor(.white)
//                        .frame(width: 30, height: 30)
                }
                Button(action: { print("panel") }) {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                }
                Button(action: { print("web") }) {
                    Image(systemName: "info.circle")
                        .modifier(ToolButtonModifier())
                }
            }
            .padding(.bottom, 12)
            .opacity(expanded ? 1.0 : 0.0)
            .frame(maxHeight: CGFloat(expanded ? .infinity : 0.0))
        }
        .frame(height: CGFloat(expanded ? 120 : 80))
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [.white, model.color]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        )
        .padding(.horizontal)
//        .animation(.default) // implicit anim
//        .animation(
//            Animation
//                .linear(duration: 0.5)
//                .delay(0.2)
//                .repeatForever(autoreverses: true)
//        )

        // manage the expanding status outside of this view
//        .onTapGesture {
//            withAnimation(
//                .spring(
//                    response: 0.55,
//                    dampingFraction: 0.425,
//                    blendDuration: 0
//                )
//            ) {
//                self.expanded.toggle()
//            }
//        }
    }
}

struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

struct PokemonInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoRow(model: .sample(id: 1), expanded: false)
        PokemonInfoRow(model: .sample(id: 21), expanded: true)
        PokemonInfoRow(model: .sample(id: 25), expanded: false)
    }
}
