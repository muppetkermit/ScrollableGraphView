
import UIKit

public protocol ScrollableGraphViewDataSource : class {
    func label(forPlot plot: Plot, atIndex pointIndex: Int) -> LabelInfo?
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double
    func label(atIndex pointIndex: Int) -> String
    func numberOfPoints() -> Int // This now forces the same number of points in each plot.
}
