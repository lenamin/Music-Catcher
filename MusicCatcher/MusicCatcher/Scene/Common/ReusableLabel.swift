//
//  ReusableLabel.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/26.
//

import UIKit

class ReusableLabel: UILabel {
    
    public private(set) var labelText: String
    public private(set) var labelColor: UIColor
    public private(set) var labelFont: UIFont
    
    init(labelText: String, labelColor: UIColor, labelFont: UIFont) {
        self.labelText = labelText
        self.labelColor = labelColor
        self.labelFont = labelFont
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false 
        let attributedString = NSMutableAttributedString(string: labelText)
        self.attributedText = attributedString
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
