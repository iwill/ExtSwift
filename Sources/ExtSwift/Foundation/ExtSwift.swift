//
//  Falsify.swift
//  ExtSwift
//
//  Created by Míng on 2021-01-09.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

internal struct ExtSwift {
    var text = "Hello, ExtSwift!"
}

// TODO: move to String+?.swift
public extension String {
    init(localizedFormat: String, comment: String? = nil, _ arguments: CVarArg...) {
        self.init(format: NSLocalizedString(localizedFormat, comment: comment ?? ""), arguments)
    }
}
