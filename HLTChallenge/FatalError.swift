//
//  FatalError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

enum FatalError: Error, CustomDebugStringConvertible {
    case couldNotDequeueCell(identifier: String)
}

extension FatalError {
    var debugDescription: String {
        switch self {
        case .couldNotDequeueCell(identifier: let id): return "Failed to dequeue resuable cell with identifier:" + id
        }
    }
}