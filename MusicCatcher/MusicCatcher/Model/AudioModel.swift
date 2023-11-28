//
//  FolderGroup.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import Foundation

class AudioModel: Codable {
    var url: String?
    var title: String? // recordName
    var tags: [String]?
    var date: String?
    var context: String?
    var folderName: String = "전체"
    
    init() {
        self.url = String()
        self.title = String()
        self.tags = [String]()
        self.date = String()
        self.context = String()
        self.folderName = String()
    }
    
    init(folderName: String, url: String, title: String) {
        self.url = url
        self.title = title
        self.tags = [String]()
        self.date = String()
        self.context = String()
        self.folderName = folderName
    }
    
    init(title: String, context: String, tags: String) {
        self.url = String()
        self.title = title
        self.tags = [tags]
        self.date = String()
        self.context = context
        self.folderName = String()
    }
    
    init(title: String, tags: [String], date: String, context: String, folderName: String) {
        self.url = String()
        self.title = title
        self.tags = tags
        self.date = date
        self.context = context
        self.folderName = folderName
    }
    
    init(url: String, title: String, tags: [String], date: String, context: String, folderName: String) {
        self.url = url
        self.title = title
        self.tags = tags
        self.date = date
        self.context = context
        self.folderName = folderName
    }
}
