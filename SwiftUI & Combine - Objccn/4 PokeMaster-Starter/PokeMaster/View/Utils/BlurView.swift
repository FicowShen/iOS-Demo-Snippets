//
//  BlurView.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/16.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {

    let style: UIBlurEffect.Style

    init(style: UIBlurEffect.Style) {
        print("init blur view")
        self.style = style
    }

    func makeUIView(
        context: UIViewRepresentableContext<BlurView>
    ) -> UIView {
        UIVisualEffectView()
    }

    func updateUIView(
        _ uiView: UIView,
        context: UIViewRepresentableContext<BlurView>) {
        print("Update UIView")
        print("style:", style.rawValue)
        guard let view = uiView as? UIVisualEffectView else {
            return
        }
        view.effect = UIBlurEffect(style: style)
    }
}

extension View {
    func blurBackground(style: UIBlurEffect.Style) -> some View {
        ZStack {
            BlurView(style: style)
            self
        }
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView(style: .dark)
    }
}
