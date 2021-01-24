//
//  File.swift
//  
//
//  Created by MingLQ on 2021-01-07.
//

import Foundation

public extension Collection {
    func ifEmpty(_ default: Self?) -> Self? {
        return isEmpty ? `default` : self
    }
    var nilIfEmpty: Self? {
        return ifEmpty(nil)
    }
}

public extension Optional where Wrapped: Collection {
    func ifEmpty(_ default: Wrapped?) -> Wrapped? {
        if let self = self, !self.isEmpty {
            return self
        }
        return `default`
    }
    var nilIfEmpty: Wrapped? {
        return ifEmpty(nil)
    }
}
