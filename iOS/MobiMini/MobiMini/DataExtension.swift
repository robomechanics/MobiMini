//
//  DataExtension.swift
//  MobiMini
//
//  Created by Edward on 7/16/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import Foundation

extension Data {
    static func dataWithValue(value: Int8) -> Data {
        var variableValue = value
        return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
    }
    
    func int8Value() -> Int8 {
        return Int8(bitPattern: self[0])
    }
}
