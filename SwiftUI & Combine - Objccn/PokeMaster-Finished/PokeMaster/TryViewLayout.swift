//
//  TryViewLayout.swift
//  PokeMaster
//
//  Created by Ficow on 2022/1/3.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import SwiftUI

struct TryViewLayout: View {
    var body: some View {
        // HStack: layout according to the proposed size
        HStack {
            // Image: ignore the proposed size
            Image(systemName: "person.circle")
            // Text: ignore the proposed height, but compress the content according to the proposed width
            Text("User:")
            Text("FicowShen | Xue Liang Shen")
        }
        .lineLimit(1)
        .frame(width: 300, height: 10)
    }
}

struct TryViewLayout_Previews: PreviewProvider {
    static var previews: some View {
        TryViewLayout()
    }
}
