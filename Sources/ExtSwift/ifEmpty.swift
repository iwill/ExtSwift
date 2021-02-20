//
//  ifEmpty.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-07.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

public extension Collection {
    func ifEmpty(_ default: Self?) -> Self? {
        return isEmpty ? `default` : self
    }
    var nonEmptyOrNil: Self? {
        return isEmpty ? nil : self
    }
}

public extension Optional where Wrapped: Collection {
    func ifEmpty(_ default: Wrapped?) -> Wrapped? {
        if let self = self, !self.isEmpty {
            return self
        }
        return `default`
    }
    var nonEmptyOrNil: Wrapped? {
        return ifEmpty(nil)
    }
}
