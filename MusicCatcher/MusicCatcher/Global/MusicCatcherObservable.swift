//
//  Observable.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/12.
//

import Foundation

class MusicCatcherObservable<T> {
  private var listener: ((T) -> Void)?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(_ closure: @escaping (T) -> Void) {
    closure(value)
    listener = closure
  }
}
