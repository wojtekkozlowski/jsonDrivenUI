//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

typealias DoneFunc = (inout Action) -> Void

protocol Action {
    var type: String { get }
    var actions: [Action] { get }
    var done: DoneFunc? {get set}
    func run()
}

extension Action {
    func run() {
        print("running \(type)...")
    }
}

class ChoiceAction: Action {
    let type = "dialog"
    let actions: [Action]
    var done: DoneFunc?
    let msg: String
    
    init(msg: String, actions: [Action] = []){
        self.actions = actions
        self.msg = msg
    }
    
    func run() {
        print("running \(type)... - \(msg)")
        if let done = done, var next = actions.first {
            done(&next)
        }
    }
    
}

class OkAction: Action {
    let type = "ok"
    let msg: String
    let actions: [Action]
    var done: DoneFunc?
    
    init(msg: String, actions: [Action] = []) {
        self.actions = actions
        self.msg = msg
    }
    
    func run() {
        print("running \(type)... - \(msg)")
        if let done = done, var action = self.actions.first {
            done(&action)
        }
     
    }
    
}

class ActionHandler {
    var action: Action
    
    init(action: Action) {
        self.action = action
    }
    
    func handle(action:inout Action) {
        action.done = { (nextAction: inout Action) -> Void in
            self.handle(action: &nextAction)
        }
        action.run()
        action.done = nil
    }
    
    func start(){
        handle(action: &self.action)
    }
}

let o1_1 = OkAction(msg: "primary 1")
let o1_2 = OkAction(msg: "secondary 1")
let c1 = ChoiceAction(msg: "choice 1", actions: [o1_1,o1_2])

let o2_1 = OkAction(msg: "primary 2")
let o2_2 = OkAction(msg: "secondary 2")
let c2 = ChoiceAction(msg: "choice 2", actions: [o2_1,o2_2])

let op = OkAction(msg: "primary -", actions:[c1])
let os = OkAction(msg: "secondary -", actions:[c2])
let c = ChoiceAction(msg: "choice -", actions: [op,os])


ActionHandler(action: c).start()



