//
//  AxisLabelDrawingLayer.swift
//  GraphView
//
//  Created by Yıldıray Mutlu on 9.08.2018.
//

import UIKit

internal class AxisLabelDrawingLayer: ScrollableGraphViewDrawingLayer {

    // PRIVATE PROPERTIES
    // ##################

    private var labelMarginTopBottom: CGFloat = 4
    private var labelSideInset: CGFloat = 10
    private var labelPosition: ScrollableGraphViewAxisLabelPosition = .topLeft
    private var labelColor: UIColor = UIColor.black
    private var labelFont: UIFont = UIFont.systemFont(ofSize: 10)
    private var lineIndex: Int = 0

    private var labels = [UILabel]()
    private var labelTexts = [LabelInfo]()

    init(frame: CGRect, labels:[LabelInfo], lineIndex: Int, color: UIColor, font: UIFont, position: ScrollableGraphViewAxisLabelPosition = .topLeft) {
        super.init(viewportWidth: frame.size.width, viewportHeight: frame.size.height)
        
        self.labelPosition = position
        self.lineIndex = lineIndex

        self.labelTexts = labels

        generateLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateLabelPositions() {
        guard let startPoint = owner?.graphPoint(forIndex: lineIndex) ,
            let endPoint = owner?.graphPoint(forIndex: lineIndex+1) else {
                return
        }

        switch labelPosition {
        case .relativeLeft, .relativeRight:
            labelTexts = owner?.graphKeyPoints(forIndex: lineIndex) ?? []
            if labelTexts.count != labels.count {
                generateLabels()
            }
        default:
            break
        }

        for index in 0..<labelTexts.count {
            let text = labelTexts[index].text
            let label = labels[index]
            let y = CGFloat(labelTexts[index].point.y)
            label.layer.frame = findLabelPosition(forText: text, startPoint: startPoint, endPoint: endPoint, relativeY: y)
        }
    }

    override func updatePath() {
        updateLabelPositions()
    }


    func generateLabels() {
        for label in labels {
            label.layer.removeFromSuperlayer()
        }
        labels = []
        for info in labelTexts {
            let label = createLabel(withText: info.text)
            self.addSublayer(label.layer)
            labels.append(label)
        }
    }

    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = labelColor
        label.font = labelFont
        return label
    }

    private func findLabelPosition(forText text: String, startPoint: GraphPoint, endPoint: GraphPoint, relativeY: CGFloat = 0) -> CGRect {
        let boundingSize = self.boundingSize(forText: text)

        var origin: CGPoint = CGPoint.zero
        switch labelPosition {
        case .topLeft:
            origin = CGPoint(x: startPoint.x - labelSideInset - boundingSize.width, y: startPoint.y + labelMarginTopBottom)
        case .topRight:
            origin = CGPoint(x: startPoint.x + labelSideInset, y: startPoint.y + labelMarginTopBottom)
        case .bottomLeft:
            origin = CGPoint(x: endPoint.x - labelSideInset - boundingSize.width, y: endPoint.y - labelMarginTopBottom)
        case .bottomRight:
            origin = CGPoint(x: endPoint.x + labelSideInset, y: endPoint.y - labelMarginTopBottom)
        case .relativeLeft:
            origin = CGPoint(x: endPoint.x - labelSideInset - boundingSize.width, y: relativeY - boundingSize.height/2)
        case .relativeRight:
            origin = CGPoint(x: endPoint.x + labelSideInset, y: relativeY - boundingSize.height/2)

        }
        return CGRect(origin: origin, size: boundingSize)
    }

    private func boundingSize(forText text: String) -> CGSize {
        return (text as NSString).size(withAttributes: [NSAttributedStringKey.font:labelFont])
    }

}
