//
//  ActionsHandler.swift
//  actions
//
//  Created by Wojtek Kozlowski on 12/01/2017.
//  Copyright © 2017 Wojtek Kozlowski. All rights reserved.
//

import Foundation

class ActionHandler {
    var action: Action

    init(action: Action) {
        self.action = action
    }

    func handle(action: inout Action) {
        action.done = { (nextAction: inout Action) in
            self.handle(action: &nextAction)
        }
        action.run()
        action.done = nil
    }

    func start() {
        handle(action: &self.action)
    }
}
