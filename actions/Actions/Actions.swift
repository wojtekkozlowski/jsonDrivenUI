//
//  Actions.swift
//  actions
//
//  Created by Wojtek Kozlowski on 12/01/2017.
//  Copyright © 2017 Wojtek Kozlowski. All rights reserved.
//

import UIKit

/// --- UIAlert 2 buttons action

typealias DoneFunc = (inout Action) -> Void

protocol Action {
    var actions: [Action]! { get set }
    var done: DoneFunc? { get set }
    weak var pvc: UIViewController? { get set }
    func run()
}


class ChoiceAction: Action {
    var actions: [Action]!
    var done: DoneFunc?
    weak var pvc: UIViewController?

    let title: String
    let button1: String
    let button2: String

    init(data: [String: AnyObject]) {
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

/// --- UIAlert 1 button action

class OkAction: Action {
    var actions: [Action]!
    var done: DoneFunc?
    weak var pvc: UIViewController?

    let title: String
    let button: String

    init(data: [String: AnyObject]) {
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
