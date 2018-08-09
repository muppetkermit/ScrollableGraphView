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
    private var prefixText: String = ""
    private var suffixText: String = ""

    private var labels = [UILabel]()
    private var labelTexts = [String]()

    init(frame: CGRect, labels:[String], lineIndex: Int, color: UIColor, font: UIFont, position: ScrollableGraphViewAxisLabelPosition = .topLeft, prefixText: String = "", suffixText: String = "") {
        super.init(viewportWidth: frame.size.width, viewportHeight: frame.size.height)

        self.labelTexts = labels
        self.labelPosition = position
        self.lineIndex = lineIndex

        self.prefixText = prefixText
        self.suffixText = suffixText

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

        var keyPoints: [(point: GraphPoint, value: Double)]?
        switch labelPosition {
        case .relativeLeft, .relativeRight:
            keyPoints = owner?.graphKeyPoints(forIndex: lineIndex)
            if let points = keyPoints {
                labelTexts.removeAll()
                for point in points {
                    labelTexts.append("\(point.value)")
                }
                if labelTexts.count != labels.count {
                    generateLabels()
                }
            }
        default:
            break
        }

        for index in 0..<labelTexts.count {
            let text = labelTexts[index]
            let label = labels[index]
            let y = (index < (keyPoints?.count ?? 0)) ? CGFloat(keyPoints?[index].point.y ?? 0) : 0
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
        for text in labelTexts {
            let label = createLabel(withText: text)
            self.addSublayer(label.layer)
            labels.append(label)
        }
    }

    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = prefixText + text + suffixText
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
        return (prefixText + text + suffixText as NSString).size(withAttributes: [NSAttributedStringKey.font:labelFont])
    }

}
