//
//  Extensions.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/7.
//

import UIKit

extension UIViewController {
    func addDescriptionLabel() {
        let label = UILabel()
        label.text = String(describing: Self.self)
        let f = { CGFloat.random(in: 0...255) / 255.0 }
        label.textColor = UIColor(red: f(), green: f(), blue: f(), alpha: 1)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

var DefaultDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss.SSS"
    formatter.timeZone = NSTimeZone.system
    return formatter
}()

func debugLog(_ msg: Any...,
              separator: String = " ",
              emoji: String = "⚠️",
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
    #if DEBUG
    let filePath: String? = (file as NSString).pathComponents.last
    let fileName: Substring? = filePath?.split(separator: ".").first
    let file: String = String(fileName ?? "UnknownFile")
    let time: String = DefaultDateFormatter.string(from: Date())
    var output: String =  "\(emoji) \(time)\n\(file) \(function)[\(line)]:\n"
    output += msg.map { "\($0)" }.joined(separator: separator)
    print(output)
    #endif
}
