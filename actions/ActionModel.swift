//
//  ActionModel.swift
//  actions
//
//  Created by Wojtek Kozlowski on 12/01/2017.
//  Copyright © 2017 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import ObjectMapper

class ActionModel: Mappable {
    var type: String!
    var data: Dictionary<String, AnyObject>?
    var actions: [ActionModel]?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        actions <- map["actions"]
        data <- map["data"]
    }
}

