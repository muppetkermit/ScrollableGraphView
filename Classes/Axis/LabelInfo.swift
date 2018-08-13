//
//  LabelInfo.swift
//  GraphView
//
//  Created by Yıldıray Mutlu on 13.08.2018.
//

import UIKit

public struct LabelInfo {
    struct Style {
        enum CornerType {
            case normal
            case rounded(radius: Int)
        }
        let cornerType: CornerType
        let backgroundColor: UIColor
        let labelColor: UIColor
    }
    
    var text: String
    var value: Double
    var style: Style
    var point: CGPoint

}
