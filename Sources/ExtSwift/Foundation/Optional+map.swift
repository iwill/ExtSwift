//
//  Optional+map.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-20.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

public extension Optional {
    func map<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U? {
        return self != nil ? try transform(self!) : nil
    }
}
