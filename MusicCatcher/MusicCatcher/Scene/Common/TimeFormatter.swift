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
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HH-mm-ss"
        return dateFormatter
    }()
    
    func dateToString(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
}

