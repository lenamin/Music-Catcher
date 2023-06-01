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

// dummy data
extension AudioModel {
    
    static let items = [AudioModel(title: "비 오는 날 생각나는",
                             tags: ["string", "verse", "발라드"],
                             date: "2023 - 03 - 23",
                             context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다",
                             folderName: "느린 곡"),
                        AudioModel(title: "재미있는 느낌",
                             tags: ["string", "chorus", "발라드"],
                             date: "2023 - 03 - 20",
                             context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다",
                             folderName: "느린 곡"),
                        AudioModel(title: "비 오는 날 생각나는",
                             tags: ["string", "비", "발라드"],
                             date: "2023 - 03 - 21",
                             context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다",
                             folderName: "느린 곡"),
                        AudioModel(title: "봄 바람",
                             tags: ["string", "비", "발라드"],
                             date: "2023 - 03 - 21",
                             context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다",
                             folderName: "미디엄템포"),
                        AudioModel(title: "비 오는 날 생각나는",
                             tags: ["string", "비", "발라드"],
                             date: "2023 - 03 - 21",
                             context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다",
                             folderName: "느린 곡"),
                        AudioModel(title: "비 오는 날 생각나는",
                             tags: ["string", "비", "발라드"],
                             date: "2023 - 03 - 21",
                             context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다",
                             folderName: "느린 곡"),
                        AudioModel(title: "새벽감성",
                             tags: ["기타", "남자가수", "발라드"],
                             date: "2023 - 03 - 21",
                             context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다",
                             folderName: "느린 곡"),
                        AudioModel(title: "뉴진스느낌",
                             tags: ["synth", "비", "발라드"],
                             date: "2023 - 03 - 21",
                             context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다",
                             folderName: "댄스")]
    

}
