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
        var action = ActionModelToAction(model: m).convert()
        action.pvc = self
        ActionHandler(action: action).start()
    }
}

typealias DoneFunc = (inout Action) -> Void

protocol Action {
    var actions: [Action]! { get set }
    var done: DoneFunc? { get set }
    weak var pvc: UIViewController? { get set }
    func run()
}
