//
//  Other.swift
//  actions
//
//  Created by Wojtek Kozlowski on 12/01/2017.
//  Copyright © 2017 Wojtek Kozlowski. All rights reserved.
//

import Foundation

func readJson() -> String {
    let filePath = Bundle.main.path(forResource: "actions", ofType: "json")
    let contentData = FileManager.default.contents(atPath: filePath!)
    return (NSString(data: contentData!, encoding: String.Encoding.utf8.rawValue) as? String)!
}
