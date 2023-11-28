//
//  Color+Extension.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/05.
//


import UIKit.UIColor

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIColor {
    static var pointColor: UIColor {
        return UIColor(rgb: 0xC825C1)
    }
    static var custombackgroundGrayColor: UIColor {
        return UIColor(rgb: 0xFCFCFC)
    }
    static var customGradientPurple: UIColor {
        return UIColor(rgb: 0xA312D7)
    }
    static var customTagPink: UIColor {
        return UIColor(rgb: 0xFFABE7)
    }
    static var customTagSky: UIColor {
        return UIColor(rgb: 0x83CBFF)
    }
    static var customTagGreen: UIColor {
        return UIColor(rgb: 0x2DC68F)
    }
    static var customTagNavy: UIColor {
        return UIColor(rgb: 0x8583FF)
    }
    static var customTagRed: UIColor {
        return UIColor(rgb: 0xFF7676)
    }
    
}
