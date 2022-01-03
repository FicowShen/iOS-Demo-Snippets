//
//  CustomAlignments.swift
//  PokeMaster
//
//  Created by Ficow on 2022/1/3.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import SwiftUI

extension VerticalAlignment {
    struct SelectAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }

    static let verticalSelect = VerticalAlignment(SelectAlignment.self)
}

extension HorizontalAlignment {
    struct SelectAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }

    static let horizontalSelect = HorizontalAlignment(SelectAlignment.self)
}

extension Alignment {
    static let select = Alignment(horizontal: .horizontalSelect,
                                  vertical: .verticalSelect)
}
