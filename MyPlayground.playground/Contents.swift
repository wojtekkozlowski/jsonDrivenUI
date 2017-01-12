//:    Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ObjectMapper

typealias DoneFunc = (inout Action) -> Void

protocol Action {
    var actions: [Action]! { get set }
    var done: DoneFunc? { get set }
    func run()
}

class ChoiceAction: Action {
    var actions: [Action]!
    var done: DoneFunc?
    var pvc: UIViewController!

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
                done(&self.actions[0])
            })
            let a2 = UIAlertAction(title: button1, style: .default, handler: { _ in
                done(&self.actions[1])
            })
            let u = UIAlertController(title: "", message: "", preferredStyle: .alert)
            u.addAction(a1)
            u.addAction(a2)
            self.pvc.present(u, animated: true, completion: nil)
        }
    }
}

class OkAction: Action {
    var actions: [Action]!
    var done: DoneFunc?
    var pvc: UIViewController!

    let title: String
    let button: String

    init(data: [String: AnyObject]) {
        title = data["title"] as! String
        button = data["button"] as! String
    }

    func run() {
        if let done = done {
            let u = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let a1 = UIAlertAction(title: "ok", style: .default, handler: { _ -> Void in
                if var action = self.actions.first {
                    done(&action)
                }
            })
            u.addAction(a1)
            self.pvc.present(u, animated: true, completion: nil)
        }
    }
}

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

let filePath = Bundle.main.path(forResource: "actions", ofType: "json")
let contentData = FileManager.default.contents(atPath: filePath!)
let json = NSString(data: contentData!, encoding: String.Encoding.utf8.rawValue) as? String

let m = Mapper<ActionModel>().map(JSONString: json!)!

struct ModelToAction {
    let model: ActionModel

    func convert() -> Action {
        return convert(model: self.model)
    }

    private func convert(model: ActionModel) -> Action {
        var a = actionForModel(model: model)
        if let actions = model.actions {
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

ModelToAction(model: m).convert()
