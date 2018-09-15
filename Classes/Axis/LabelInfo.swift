//
//  LabelInfo.swift
//  GraphView
//
//  Created by Yıldıray Mutlu on 13.08.2018.
//

import UIKit

public struct LabelInfo {
    public struct Style {
        public enum CornerType {
            case normal
            case rounded(radius: Int)
        }
        public let cornerType: CornerType
        public let backgroundColor: UIColor
        public let labelColor: UIColor
        public let size: CGSize?
        public let font: UIFont
        
        public init(cornerType: CornerType, backgroundColor: UIColor, labelColor: UIColor,
                    size: CGSize?, font: UIFont) {
            self.cornerType = cornerType
            self.backgroundColor = backgroundColor
            self.labelColor = labelColor
            self.size = size
            self.font = font
        }
    }
    
    public var text: String
    public var value: Double
    public var style: Style
    public var point: CGPoint
    public var position: ScrollableGraphViewAxisLabelPosition

    public init(text: String, value: Double, style: Style,
                point: CGPoint, position: ScrollableGraphViewAxisLabelPosition) {
        self.text = text
        self.value = value
        self.style = style
        self.point = point
        self.position = position
    }
}

