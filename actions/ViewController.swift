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
    
    let ut = UITextView()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.addSubview(ut)
        ut.layer.borderColor = UIColor.black.cgColor
        ut.layer.borderWidth = 2
        ut.text = readJson()
        ut.translatesAutoresizingMaskIntoConstraints = false
    
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(b)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[textView]-[button(40)]-(20)-|", options: [], metrics: nil, views: ["textView":ut, "button":b]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textView]-|", options: [], metrics: nil, views: ["textView":ut]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|", options: [], metrics: nil, views: ["button":b]))
        b.setTitle("execute", for: .normal)
        b.backgroundColor = .blue
        b.addTarget(self, action: #selector(bp), for: .touchUpInside)
    }
    
    func bp(){
        if let m = Mapper<ActionModel>().map(JSONString: ut.text!) {
            var action = ActionModelToAction(model: m).convert()
            action.pvc = self
            ActionHandler(action: action).start()
        } else {
            print("wrong json")
        }
        
    }
}

