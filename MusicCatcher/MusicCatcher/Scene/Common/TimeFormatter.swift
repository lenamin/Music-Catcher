//
//  TimeFormatter.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/18.
//

import Foundation

class MyDateFormatter {
    
    static let shared = MyDateFormatter()
    
    private init() {}
    
    private let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HH-mm-ss"
        return dateFormatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        return dateFormatter
    }()
    
    func timeToString(from date: Date) -> String {
        timeFormatter.string(from: date)
    }
    
    func dateToString(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
}

