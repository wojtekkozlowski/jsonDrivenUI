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

struct ActionModelToAction {
    let model: ActionModel

    func convert() -> Action {
        return convert(model: self.model)
    }

    private func convert(model: ActionModel) -> Action {
        var a = actionForModel(model: model)
        if let actions = model.actions {
            a.actions = actions.map { convert(model: $0) }
        }
        return a
    }

    private func actionForModel(model: ActionModel) -> Action {
        switch model.type {
        case "CHOICE": return ChoiceAction(data: model.data!)
        case "OK": return OkAction(data: model.data!)
        default: fatalError(); break
        }
    }
}
