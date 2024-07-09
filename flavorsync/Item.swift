//
//  Item.swift
//  flavorsync
//
//  Created by Aria Han on 7/9/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
