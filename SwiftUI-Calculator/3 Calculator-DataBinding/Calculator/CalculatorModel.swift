//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Ficow on 2021/12/12.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine

class CalculatorModel: ObservableObject {

    // Replace template code with @Published
//    let objectWillChange = PassthroughSubject<Void, Never>()
//
//    var brain: CalculatorBrain = .left("0") {
//        willSet {
//            objectWillChange.send()
//        }
//    }

//    @Published var brain: CalculatorBrain = .left("0")
//    @Published var history: [CalculatorButtonItem] = []

    private(set) var brain: CalculatorBrain = .left("0")
    private(set) var history: [CalculatorButtonItem] = []

    // replace @Published with manual emitting events for better performance
    let objectWillChange = PassthroughSubject<Void, Never>()

    var historyDetail: String {
        history.map { $0.description }.joined()
    }

    var temporaryKept: [CalculatorButtonItem] = []

    var totalCount: Int {
        history.count + temporaryKept.count
    }

    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }

    private func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        let total = history + temporaryKept
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        brain = history.reduce(CalculatorBrain.left("0")) {
            result, item in
            result.apply(item: item)
        }
        objectWillChange.send()
    }


    func apply(_ item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item)
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
        objectWillChange.send()
    }
}
