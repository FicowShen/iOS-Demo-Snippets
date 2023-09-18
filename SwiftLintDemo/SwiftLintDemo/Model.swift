//
//  Model.swift
//  SwiftLintDemo
//
//  Created by Ficow on 2023/9/18.
//

import Foundation
import Dispatch
import SwiftShims

struct Model {
    // large_tuple
    static func parsedValuesFromString(_ s: String) -> ((String,String,String), String, String)? { // identifier_name, large_tuple
        let parts = s.split(separator: "#").map { String.init($0) } // explicit_init
        guard parts.count == 3 else {
            return nil
        }
        let cityInfo = parts[0].split(separator: "/").map { String.init($0) } // explicit_init
        guard cityInfo.count == 3 else {
            return nil
        }
        return ((cityInfo[0], cityInfo[1], cityInfo[2]), parts[1], parts[2])
    }

    static func parsedModelFromString(_ s: String) -> Model? { // identifier_name
        guard let info = parsedValuesFromString(s) else { return nil }
        return Model.init(city: info.0.0, province: info.0.1, country: info.0.2, postalCode: info.1, population: info.2) // explicit_init
    }

    // FIXME: <FICOW> check the value carefully
    static let gz = parsedModelFromString("China/Guangdong/Guangzhou#510000#18,734,000")! // force_unwrapping
    static let xa = parsedModelFromString("China/Shaanxi/Xi'an#710000#12,952,907")!

    let city :  String // colon
    let province : String
    let country:  String
    let postalCode: String
    let population: String
}
