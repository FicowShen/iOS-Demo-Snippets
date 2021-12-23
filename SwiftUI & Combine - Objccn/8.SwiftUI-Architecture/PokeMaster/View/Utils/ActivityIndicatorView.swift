//
//  ActivityIndicatorView.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {

    typealias View = UIActivityIndicatorView

    let style: View.Style

    func makeUIView(context: UIViewRepresentableContext<Self>) -> View {
        View()
    }

    func updateUIView(_ uiView: View, context: UIViewRepresentableContext<Self>) {
        uiView.style = style
        uiView.startAnimating()
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView(style: .medium)
    }
}
