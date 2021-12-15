//
//  ContentView.swift
//  Calculator
//
//  Created by Ficow on 2021/12/11.
//

import SwiftUI

struct ContentView: View {

    let scale: CGFloat = UIScreen.main.bounds.width / 375

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Spacer()
            Text("0")
                .foregroundColor(Color("resultDigitBackground"))
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
//                .foregroundColor(.black) // incompatible with dark mode
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .trailing
                )

            // use frame to set bottom & trailing alignment
//            Text("0")
//                .font(.system(size: 76))
//                .minimumScaleFactor(0.5)
//                .padding(.trailing, 24)
//                .lineLimit(1)
//                .frame(
//                    minWidth: 0,
//                    maxWidth: .infinity,
//                    minHeight: 0,
//                    maxHeight: .infinity,
//                    alignment: .bottomTrailing
//                )

            // use a spacer to set trailing alignment
//            HStack {
//                Spacer()
//                Text("0")
//                    .font(.system(size: 76))
//                    .minimumScaleFactor(0.5)
//                    .padding(.trailing, 24)
//                    .lineLimit(1)
//            }
            CalculatorButtonPad()
                .padding(.bottom)
        }
        // scaleEffect may not work
//        .scaleEffect(scale)
    }
}

struct CalculatorButtonPad: View {
    let pad: [[CalculatorButtonItem]] = [
        [.command(.clear), .command(.flip),
         .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.digit(0), .dot, .op(.equal)]
    ]
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self) {
                row in CalculatorButtonRow(row: row)
            }
        }
    }
}

struct CalculatorButtonRow: View {
    let row: [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    backgroundColorName: item.backgroundColorName) {
                    print("Button: \(item.title)")
                }
            }
        }
    }
}

struct CalculatorButton : View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width / 2)
        }
    }
}


struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
        ContentView()
            .previewDevice("iPhone 8")
            .preferredColorScheme(.dark)
        /// get simulator list by CLI command: `xcrun simctl list devicetypes`
        ContentView()
            .previewDevice("com.apple.CoreSimulator.SimDeviceType.iPad-Air--4th-generation-")
        //        ZStack {
        //            Circle()
        //            Text("?")
        //                .font(.system(size: 76))
        //                .foregroundColor(.white)
        //        }
    }
}
