//
//  ContentView.swift
//  Calculator
//
//  Created by Ficow on 2021/12/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("+")
            .font(.title)
            .foregroundColor(.white)
            .background(Color.orange)
            .padding()
            .background(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
