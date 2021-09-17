//
//  main.swift
//  HexCodeToCharacter
//
//  Created by FicowShen on 2021/9/17.
//

import Foundation

let s = "0x76 0x65 0x72 0x73 0x69 0x6F 0x6E 0x20 0x68 0x74 0x74 0x70 0x73 0x3A 0x2F 0x2F"
func characterForHexCode(_ hex: String) -> Character {
    let code = hex.replacingOccurrences(of: "0x", with: "").lowercased()
    let chars: [Character] = Array(code)
    var scalar = 0, radix = 16
    for i in stride(from: 0, through: chars.count - 1, by: 1) {
        let pos = chars.count - 1 - i
        let c = chars[i], carry = (pos == 0 ? 1 : radix * pos)
        if c.isNumber {
            scalar += Int(c.asciiValue! - 48) * carry
        } else {
            scalar += (Int(c.asciiValue! - 97) + 10) * carry
        }
    }
    return Character(UnicodeScalar(scalar)!)
}
let res = s.split(separator: " ").map { s -> Character in
    characterForHexCode(String(s))
}

print(res.reduce(into: "", { $0.append($1) }))
