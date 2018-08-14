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
            if let enumValue = LinePositioningType(rawValue: newValue) {
                axisLinePosition = enumValue
            }
        }
    }
    /// How the axis line should be displayed on the graph
    open var axisLinePosition = LinePositioningType.relative

    /// axis line absolute position ratio
    @IBInspectable var axisLineAbsoluteRatio: Double = 0.5

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
    public var labelInfo = LabelInfo(text: "",
                                     value: 0,
                                     style: LabelInfo.Style(cornerType: .normal, backgroundColor: UIColor.clear, labelColor: UIColor.black),
                                     point: CGPoint.zero)

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

    func updateLineLayer() {
        createAxisPoints()
        _ = lineLayer?.createLinePath()
    }

    private func createAxisPoints() {
        let positions = graphViewDrawingDelegate.calculateAxisPosition(atIndex: axisLineIndex, lineType: axisLinePosition)
        if case LinePositioningType.absolute = axisLinePosition {
            let x = (positions.end.x + positions.start.x) * CGFloat(axisLineAbsoluteRatio)
            graphPoints = [GraphPoint(position: CGPoint(x: x, y: positions.start.y)), GraphPoint(position: CGPoint(x: x, y: positions.end.y))]
        } else {
            graphPoints = [GraphPoint(position: positions.start), GraphPoint(position: positions.end)]
        }
    }

    private func createLayers(viewport: CGRect) {
        // Create the line drawing layer.
        lineLayer = LineDrawingLayer(frame: viewport, lineWidth: axisLineThickness, lineColor: axisLineColor, lineStyle: ScrollableGraphViewLineStyle.straight)
        lineLayer?.linePositionType = axisLinePosition
        lineLayer?.owner = self

        if shouldShowLabels {
            labelInfo.text = labelText
            labelLayer = AxisLabelDrawingLayer(frame: viewport, labels:[labelInfo] , lineIndex: axisLineIndex, color: dataPointLabelColor, font: dataPointLabelFont, position: axisLabelPosition)
            labelLayer?.linePositionType = axisLinePosition
            labelLayer?.owner = self
        }
    }

    internal func graphKeyPoints(forIndex index: Int) -> [LabelInfo] {
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

@objc public enum ScrollableGraphViewAxisLabelPosition : Int {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case relativeLeft
    case relativeRight
}
