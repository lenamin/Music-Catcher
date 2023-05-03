//
//  FolderGroup.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import Foundation

struct Folder {
    var name: String
    var items: [Item]
}

struct Item {
    var title: String
    var tags: [Tag]
    var date: String
    var duration: Int
    var context: String
    
    init() {
        self.title = String()
        self.tags = [Tag]()
        self.date = String()
        self.duration = Int()
        self.context = String()
    }
    
    init(title: String, tags: [Tag], date: String, duration: Int, context: String) {
        self.title = title
        self.tags = tags
        self.date = date
        self.duration = duration
        self.context = context
    }
}

struct Tag {
    var tag: String
}

// dummy data
extension Folder {
    static let forders = [
        Folder(name: "전체",
               items: [Item(title: "비 오는 날 생각나는",
                           tags: [Tag(tag: "string"), Tag(tag: "비"), Tag(tag: "발라드")],
                           date: "2023 - 03 - 21",
                           duration: 128,
                           context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다"),
                      Item(title: "새벽감성",
                           tags: [Tag(tag: "알앤비"), Tag(tag: "ep")],
                           date: "2023 - 03 - 24",
                           duration: 182,
                           context: "ep 소스 좀 더 다듬으면 좋을 알앤비. jorja smith 느낌을 내고싶었다. 여자보컬 필요"),
                       Item(title: "봄",
                            tags: [Tag(tag: "미디엄템포")],
                            date: "2023 - 03 - 25",
                            duration: 182,
                            context: "봄에 듣기 좋은 상큼하지만 미디엄템포의 발라드")]),
        Folder(name: "느린 곡들",
               items: [Item(title: "비 오는 날 생각나는",
                           tags: [Tag(tag: "string"), Tag(tag: "비"), Tag(tag: "발라드")],
                           date: "2023 - 03 - 21",
                           duration: 128,
                           context: "비 오는 봄에 떨어진 벚꽃을 보고 내 사랑도 이 잠깐 펴고 지는 벚꽃처럼 찰나였구나, 이미 졌구나, 라는 느낌의 가사이면 좋겠다"),
                      Item(title: "새벽감성",
                           tags: [Tag(tag: "알앤비"), Tag(tag: "ep")],
                           date: "2023 - 03 - 24",
                           duration: 182,
                           context: "ep 소스 좀 더 다듬으면 좋을 알앤비. jorja smith 느낌을 내고싶었다. 여자보컬 필요"),
                       Item(title: "봄",
                            tags: [Tag(tag: "미디엄템포")],
                            date: "2023 - 03 - 25",
                            duration: 182,
                            context: "봄에 듣기 좋은 상큼하지만 미디엄템포의 발라드")]),
        Folder(name: "댄스",
               items: [Item(title: "뉴진스 느낌",
                           tags: [Tag(tag: "synth"), Tag(tag: "여자아이돌"), Tag(tag: "Ekey"), Tag(tag: "808 kick")],
                           date: "2023 - 02 - 10",
                           duration: 112,
                           context: "attention같은 느낌에 좀 더 화성감을 줘서 + 백코러스 뽷!! "),
                      Item(title: "남자아이돌",
                           tags: [Tag(tag: "synth")],
                           date: "2023 - 01 - 11",
                           duration: 204,
                           context: "그냥 갑자기 생각난 루프")]),
        Folder(name: "탑라인",
               items: [Item(title: "뉴진스 느낌",
                           tags: [Tag(tag: "synth"), Tag(tag: "여자아이돌"), Tag(tag: "Ekey"), Tag(tag: "808 kick")],
                           date: "2023 - 02 - 10",
                           duration: 112,
                           context: "attention같은 느낌에 좀 더 화성감을 줘서 + 백코러스 뽷!! "),
                      Item(title: "남자아이돌",
                           tags: [Tag(tag: "synth")],
                           date: "2023 - 01 - 11",
                           duration: 204,
                           context: "그냥 갑자기 생각난 루프")]),
        Folder(name: "비트메이킹",
               items: [Item(title: "뉴진스 느낌",
                           tags: [Tag(tag: "synth"), Tag(tag: "여자아이돌"), Tag(tag: "Ekey"), Tag(tag: "808 kick")],
                           date: "2023 - 02 - 10",
                           duration: 112,
                           context: "attention같은 느낌에 좀 더 화성감을 줘서 + 백코러스 뽷!! "),
                      Item(title: "남자아이돌",
                           tags: [Tag(tag: "synth")],
                           date: "2023 - 01 - 11",
                           duration: 204,
                           context: "그냥 갑자기 생각난 루프")]),
        Folder(name: "다른 음악",
               items: [Item(title: "뉴진스 느낌",
                           tags: [Tag(tag: "synth"), Tag(tag: "여자아이돌"), Tag(tag: "Ekey"), Tag(tag: "808 kick")],
                           date: "2023 - 02 - 10",
                           duration: 112,
                           context: "attention같은 느낌에 좀 더 화성감을 줘서 + 백코러스 뽷!! "),
                      Item(title: "남자아이돌",
                           tags: [Tag(tag: "synth")],
                           date: "2023 - 01 - 11",
                           duration: 204,
                           context: "그냥 갑자기 생각난 루프")])]
}
