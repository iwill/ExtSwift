//
//  ifEmpty.swift
//  ExtSwift
//
//  Created by Míng on 2021-01-07.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

public extension Collection {
    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
}

public extension Optional where Wrapped: Collection {
    var nonEmpty: Wrapped? {
        if let self, !self.isEmpty {
            return self
        }
        return nil
    }
}
