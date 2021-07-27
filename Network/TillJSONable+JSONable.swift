//
//  HTJSONable+JSONable.swift
//  
//
//  Created by VB on 28/12/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol JSONable {
    init?(parameter: JSON)
}

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONable.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                arrObject = self.arrayValue.map { baseObj.init(parameter: $0)! }
                return arrObject
            } else {
                let object = baseObj.init(parameter: self)
                return object!
            }
        }
        return nil
    }
}
