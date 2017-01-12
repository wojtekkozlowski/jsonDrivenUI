//
//  ViewController.swift
//  actions
//
//  Created by Wojtek Kozlowski on 12/01/2017.
//  Copyright © 2017 Wojtek Kozlowski. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let m = Mapper<ActionModel>().map(JSONString: readJson())!
        var action = ModelToAction(model: m).convert()
        action.pvc = self
        ActionHandler(action: action).start()
    }

}


typealias DoneFunc = (inout Action) -> Void

protocol Action {
    var actions: [Action]! { get set }
    var done: DoneFunc? { get set }
    weak var pvc: UIViewController? {get set}
    func run()
}

class ChoiceAction: Action {
    var actions: [Action]!
    var done: DoneFunc?
    weak var pvc: UIViewController?
    
    let title: String
    let button1: String
    let button2: String
    
    init(data: [String: AnyObject]){
        title = data["title"] as! String
        button1 = data["button1"] as! String
        button2 = data["button2"] as! String
    }
    
    func run() {
        
        if let done = done {
            let a1 = UIAlertAction(title: button1, style: .default, handler: { _ in
                self.actions[0].pvc = self.pvc
                done(&self.actions[0])
            })
            let a2 = UIAlertAction(title: button2, style: .default, handler: { _ in
                self.actions[1].pvc = self.pvc
                done(&self.actions[1])
            })
            let u = UIAlertController(title: title, message: title, preferredStyle: .alert)
            u.addAction(a1)
            u.addAction(a2)
            self.pvc!.present(u, animated: true, completion: nil)
        }
    }
    
}

class OkAction: Action {
    var actions: [Action]!
    var done: DoneFunc?
    weak var pvc: UIViewController?
    
    let title: String
    let button: String
    
    init(data: [String: AnyObject]){
        title = data["title"] as! String
        button = data["button"] as! String
    }
    
    func run() {
        if let done = done {
            let u = UIAlertController(title: title, message: title, preferredStyle: .alert)
            let a1 = UIAlertAction(title: button, style: .default, handler: { _ -> Void in
                if let actions = self.actions, var action = actions.first {
                    action.pvc = self.pvc
                    done(&action)
                }
            })
            u.addAction(a1)
            self.pvc!.present(u, animated: true, completion: nil)
        }
    }
    
}




struct ModelToAction{
    let model: ActionModel
    
    func convert() -> Action {
        return convert(model: self.model)
    }
    
    private func convert(model: ActionModel) -> Action{
        var a = actionForModel(model: model)
        if let actions =  model.actions {
            a.actions = actions.map { actionForModel(model: $0) }
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

class ActionHandler {
    var action: Action
    
    init(action: Action) {
        self.action = action
    }
    
    func handle(action:inout Action) {
        action.done = { (nextAction: inout Action) in
            self.handle(action: &nextAction)
        }
        action.run()
        action.done = nil
    }
    
    func start(){
        handle(action: &self.action)
    }
}


