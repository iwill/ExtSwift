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
        guard let self = self, !self.isEmpty else {
            return `default`
        }
        return self
    }
    var nilIfEmpty: Wrapped? {
        return ifEmpty(nil)
    }
}
