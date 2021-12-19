import Combine


check("Remove Duplicates") {
    ["S", "Sw", "Sw", "Sw", "Swi",
     "Swif", "Swift", "Swift", "Swif"]
        .publisher
        .removeDuplicates()
}


check("Flat Map 2") {
    ["A", "B", "C"]
        .publisher
        .flatMap { letter in
            [1, 2, 3]
                .publisher
                .map { "\(letter)\($0)" }
        }
}

// flatMap 将外层 Publisher 发出的事件中的值传递给内层 Publisher，然 后汇总内层 Publisher 给出的事件输出，作为最终变形后的结果
check("Flat Map 1") {
    [[1, 2, 3], ["a", "b", "c"]]
        .publisher
        .flatMap {
            $0.publisher
        }
}


check("Compact Map") {
    ["1", "2", "3", "cat", "5"]
        .publisher
        .compactMap { Int($0) }
}


check("Compact Map By Filter") {
    ["1", "2", "3", "cat", "5"]
        .publisher
        .map { Int($0) }
        .filter { $0 != nil }
        .map { $0! }
}


check("Scan") {
    [1, 2, 3]
        .publisher
        .scan(0, +)
}

check("Scan 2") {
    [(), (), ()]
        .publisher
        .scan(0, { v, _ in v + 1 })
}


check("Reduce") {
    [1, 2, 3]
        .publisher
        .reduce(0, +)
}


check("Array") {
    [1, 2, 3]
        .publisher
        .map { $0 * 2 }
}


check("Empty") {
    Empty<Int, SampleError>()
}


check("Just") {
    Just("Hello SwiftUI")
}



//let publisher = CurrentValueSubject<Int, Never>(0)
//print("开始订阅")
//publisher.sink(
//receiveCompletion: { complete in print(complete)
//},
//receiveValue: { value in
//    print(value)
//  }
//)
//publisher.value = 1
//publisher.value = 2
//publisher.send(3)
//publisher.send(completion: .finished)
//print("--- \(publisher.value) ---")


//let publisher = CurrentValueSubject<Int, Never>(0)
//publisher.value = 1
//publisher.value = 2
//publisher.send(completion: .finished)
//print("开始订阅")
//publisher.sink(
//receiveCompletion: { complete in print(complete)
//},
//receiveValue: { value in
//    print(value)
//  }
//)



//let publisher = PassthroughSubject<Int, Never>()
//publisher.send(1)
//publisher.send(2)
//publisher.send(completion: .finished)
//
//print("开始订阅")
//publisher.sink(
//    receiveCompletion: {
//        complete in print(complete)
//    },
//    receiveValue: {
//        value in print(value)
//    }
//)
//
//publisher.send(3)
//publisher.send(completion: .finished)
