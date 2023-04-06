//
//  GradientColor+Extension.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/06.
//

import UIKit

extension UIView {
    
    /// gradient 색상, gradient 방향을 결정
    func setGradientColor(firstColor: UIColor,
                          secondColor: UIColor,
                          startPointNumber: CGPoint,
                          endPointNumber: CGPoint) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.locations = [0.0, 1.0] // 이거 왜 필요하지?
        gradient.startPoint = startPointNumber
        gradient.endPoint = endPointNumber
        gradient.frame = self.bounds
        layer.addSublayer(gradient)
    }
}
