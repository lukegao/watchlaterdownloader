//
//  models.swift
//  MacApp
//
//  Created by Luke Gao on 1/15/15.
//  Copyright (c) 2015 Luke Gao. All rights reserved.
//

import Foundation

struct UserInfomation {
    var avartarImage: NSImage?
    var userMail: String = ""
}

struct VideoContent {
    let id: String
    var thumbNail: NSImage?
    var localFile: NSURL?
    var title: String!
    var embedHtml: String = ""
    
    init(id: String) {
        self.id = id
    }
}
