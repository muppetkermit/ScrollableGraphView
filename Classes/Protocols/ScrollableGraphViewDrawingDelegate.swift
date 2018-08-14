
import UIKit

// Delegate definition that provides the data required by the drawing layers.
internal protocol ScrollableGraphViewDrawingDelegate : class {
    func intervalForActivePoints() -> CountableRange<Int>
    func intervalForAbsolutePoints() -> CountableRange<Int>
    func rangeForActivePoints() -> (min: Double, max: Double)
    func paddingForPoints() -> (leftmostPointPadding: CGFloat, rightmostPointPadding: CGFloat)
    func calculatePosition(atIndex index: Int, value: Double) -> CGPoint
    func calculateAxisPosition(atIndex index: Int, lineType: LinePositioningType) -> (start:CGPoint, end:CGPoint)
    func calculateAxisPositionForRelativeLabels(atIndex index: Int) -> [LabelInfo]
//    func calculateAxisPositionForRelativeLabels(atIndex index: Int) -> [(point: GraphPoint, value: Double)]?
    func currentViewport() -> CGRect
    func updatePaths()
}
