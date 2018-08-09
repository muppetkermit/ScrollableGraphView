//
//  File.swift
//  GraphView
//
//  Created by Yıldıray Mutlu on 8.08.2018.
//

import UIKit

// Currently just a simple data structure to hold the settings for the reference lines.
open class AxisLine: GraphPlot {

    // The id for this Axis. Used when determining which data to give it in the dataSource
    open var identifier: String!

    weak var graphViewDrawingDelegate: ScrollableGraphViewDrawingDelegate! = nil

    // Axis Lines
    // ###############

    /// The thickness of the reference lines.
    @IBInspectable open var axisLineIndex: Int = 0

    /// Whether or not to show the x-axis reference lines and labels.
    @IBInspectable open var shouldShowAxisLines: Bool = true
    /// The colour for the reference lines.
    @IBInspectable open var axisLineColor: UIColor = UIColor.black
    /// The thickness of the reference lines.
    @IBInspectable open var axisLineThickness: CGFloat = 1

    @IBInspectable var axisLinePosition_: Int {
        get { return axisLinePosition.rawValue }
        set {
            if let enumValue = AxisLinePositioningType(rawValue: newValue) {
                axisLinePosition = enumValue
            }
        }
    }
    /// Where the labels should be displayed on the reference lines.
    open var axisLinePosition = AxisLinePositioningType.relative

    /// How each segment in the line should connect. Takes any of the Core Animation LineJoin values.
    open var lineJoin: String = kCALineJoinRound

    /// The line caps. Takes any of the Core Animation LineCap values.
    open var lineCap: String = kCALineCapRound

    private var lineLayer: LineDrawingLayer?
    private var labelLayer: AxisLabelDrawingLayer?

    private var graphPoints = [GraphPoint]()

    private var labelMarginTopBottom: CGFloat = 6
    private var labelSideInset: CGFloat = 10
    /// Whether or not to show the labels on the x-axis.
    @IBInspectable open var shouldShowLabels: Bool = true

    /// Text for the labels on the x-axis.
    @IBInspectable open var labelText: String = "Axis"
    /// Prefix for the labels on the x-axis.
    @IBInspectable open var prefixText: String = ""
    /// Suffix for the labels on the x-axis.
    @IBInspectable open var suffixText: String = ""

    @IBInspectable var axisLabelPosition_: Int {
        get { return axisLabelPosition.rawValue }
        set {
            if let enumValue = ScrollableGraphViewAxisLabelPosition(rawValue: newValue) {
                axisLabelPosition = enumValue
            }
        }
    }
    /// Where the labels should be displayed on the reference lines.
    open var axisLabelPosition = ScrollableGraphViewAxisLabelPosition.topLeft

    /// How far from the "minimum" reference line the data point labels should be rendered.
    @IBInspectable open var dataPointLabelTopMargin: CGFloat = 10
    /// How far from the bottom of the view the data point labels should be rendered.
    @IBInspectable open var dataPointLabelBottomMargin: CGFloat = 0
    /// The font for the data point labels.
    @IBInspectable open var dataPointLabelColor: UIColor = UIColor.black
    /// The colour for the data point labels.
    open var dataPointLabelFont: UIFont = UIFont.systemFont(ofSize: 10)

    func layers(forViewport viewport: CGRect) -> [ScrollableGraphViewDrawingLayer?] {
        createLayers(viewport: viewport)
        return [lineLayer,labelLayer]
    }

    func setup() {
        createAxisPoints()
    }

    private func createAxisPoints() {
        let positions = graphViewDrawingDelegate.calculateAxisPosition(atIndex: axisLineIndex)
        graphPoints.append(GraphPoint(position: positions.start))
        graphPoints.append(GraphPoint(position: positions.end))
    }

    private func createLayers(viewport: CGRect) {
        // Create the line drawing layer.
        lineLayer = LineDrawingLayer(frame: viewport, lineWidth: axisLineThickness, lineColor: axisLineColor, lineStyle: ScrollableGraphViewLineStyle.straight)
        lineLayer?.owner = self

        if shouldShowLabels {
            labelLayer = AxisLabelDrawingLayer(frame: viewport, labels: [labelText], lineIndex: axisLineIndex, color: dataPointLabelColor, font: dataPointLabelFont, position: axisLabelPosition, prefixText: prefixText, suffixText: suffixText)
            labelLayer?.owner = self
        }
    }

    internal func graphKeyPoints(forIndex index: Int) -> [(point: GraphPoint, value: Double)]? {
        return graphViewDrawingDelegate.calculateAxisPositionForRelativeLabels(atIndex: index)
    }

    internal func graphPoint(forIndex index: Int) -> GraphPoint? {
        let point = index - axisLineIndex
        if point <= 1 && point >= 0 {
            return graphPoints[point]
        }
        return nil
    }
    
    // move path for single lines.
    func graphMove() -> GraphPoint? {
        return graphPoints[0]
    }
    
}

@objc public enum AxisLinePositioningType : Int {
    case relative
    case absolute
}

@objc public enum ScrollableGraphViewAxisLabelPosition : Int {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case relativeLeft
    case relativeRight
}
