//
//  HistoryView.swift
//  Calculator
//
//  Created by Ficow on 2021/12/12.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var model: CalculatorModel

//    @Binding var isPresented: Bool
    // show & hide a sheet: https://www.swiftbysundell.com/articles/dismissing-swiftui-modal-and-detail-views/
    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.dismiss) private var dismiss // iOS 15

    var body: some View {
        VStack {
            Spacer()
            VStack {
                if model.totalCount == 0 {
                    Text("没有履历")
                } else {
                    HStack {
                        Text("履历").font(.headline)
                        Text("\(model.historyDetail)").lineLimit(nil)
                    }
                    HStack {
                        Text("显示").font(.headline)
                        Text("\(model.brain.output)")
                    }
                    Slider(
                        value: $model.slidingIndex,
                        in: 0...Float(model.totalCount),
                        step: 1
                    )
                }
            }.padding()
            Spacer()
            Button("关闭") {
                presentationMode.wrappedValue.dismiss()
                // iOS 15, call as function feature: https://www.swiftbysundell.com/articles/exploring-swift-5-2s-new-functional-features/#calling-types-as-functions
                // dismiss()
//                isPresented = false
            }
            .padding(.bottom, 20)
        }
    }
}
