//
//  Falsify.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

struct ExtSwift {
    var text = "Hello, ExtSwift!"
}

public func mutating<T>(_ value: T, mutate: (inout T) -> Void) -> T {
    var value = value
    mutate(&value)
    return value
}
