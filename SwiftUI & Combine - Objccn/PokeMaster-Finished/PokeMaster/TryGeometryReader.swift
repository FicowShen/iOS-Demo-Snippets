//
//  TryGeometryReader.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/31.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct CircleInfo: Identifiable {
    let id = UUID()
    let offset: CGPoint
    let color: Color
}

struct TryGeometryReader: View {
    let size: CGSize

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let len = min(width, height)
            let circleInfo: [CircleInfo] = [
                .init(offset: .init(x: 0, y: -len), color: .red),
                .init(offset: .init(x: width, y: 0), color: .yellow),
                .init(offset: .init(x: 0, y: height), color: .green),
                .init(offset: .init(x: -len, y: 0), color: .blue),
            ]
            ForEach(circleInfo) { info in
                Circle()
                    .path(
                        in: .init(x: 0, y: 0, width: len, height: len)
                    )
                    .offset(x: info.offset.x, y: info.offset.y)
                    .foregroundColor(info.color)
            }
        }
        .frame(width: size.width, height: size.height)
        .border(Color.blue, width: 1)
        .background(Color.gray.opacity(0.3))
    }
}

struct TryGeometryReader_Previews: PreviewProvider {
    static var previews: some View {
        TryGeometryReader(size: .init(width: 100, height: 100))
        TryGeometryReader(size: .init(width: 50, height: 100))
        TryGeometryReader(size: .init(width: 100, height: 50))
    }
}
