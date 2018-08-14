//
//  SingleGraphViewController.swift
//  GraphView
//
//  Created by Yıldıray Mutlu on 8.08.2018.
//

import UIKit

class SingleGraphViewController: UIViewController {


    var graphView: ScrollableGraphView!
    var graphConstraints = [NSLayoutConstraint]()

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView = createSimpleGraph(self.view.frame)

        self.view.addSubview(graphView)
        setupConstraints()
    }
    
    fileprivate func createSimpleGraph(_ frame: CGRect) -> ScrollableGraphView {

        // Compose the graph view by creating a graph, then adding any plots
        // and reference lines before adding the graph to the view hierarchy.
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)

        let linePlot = DotPlot(identifier: "black") // Identifier should be unique for each plot.

        // Setup the second plot.
        let orangeLinePlot = DotPlot(identifier: "green")

//        orangeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#71D637")
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        // squares on the line
        let orangeSquarePlot = DotPlot(identifier: "multiOrangeSquare")
        orangeSquarePlot.dataPointType = ScrollableGraphViewDataPointType.square
        orangeSquarePlot.dataPointSize = 5
        orangeSquarePlot.dataPointFillColor = UIColor.colorFromHex(hexString: "#71D637")

        orangeSquarePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        let referenceLines = ReferenceLines()
        let axisLine1 = AxisLine()
        axisLine1.axisLineIndex = 10
        axisLine1.labelText = "Lap 1"
        axisLine1.axisLabelPosition = .relativeRight
        axisLine1.axisLinePosition = .absolute
        let axisLine2 = AxisLine()
        axisLine2.axisLineIndex = 30
        axisLine2.labelText = "⭐️ Lap 2"
        axisLine2.axisLabelPosition = .topRight
        

        graphView.shouldAnimateOnStartup = false
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: orangeLinePlot)
        graphView.addAxisLine(axisLine: axisLine1)
        graphView.addAxisLine(axisLine: axisLine2)
        graphView.addReferenceLines(referenceLines: referenceLines)

        return graphView
    }

    private func setupConstraints() {

        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()

        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)

        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)

        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)

        //graphConstraints.append(heightConstraint)

        self.view.addConstraints(graphConstraints)
    }

    // Data for graphs with a single plot
    lazy var simpleLinePlotData: [Double] = self.generateRandomData(60, max: 100, shouldIncludeOutliers: false)
    lazy var orangeLinePlotData: [Double] =  self.generateRandomData(60, max: 40, shouldIncludeOutliers: true)

    // Data Generation
    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)

            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }

            data.append(randomNumber)
        }
        return data
    }
}

extension SingleGraphViewController: ScrollableGraphViewDataSource {

    func label(forPlot plot: Plot, atIndex pointIndex: Int) -> LabelInfo? {
        guard let point = plot.graphPoint(forIndex: pointIndex) else {
            return nil
        }
        var suffix = ""
        var style = LabelInfo.Style(cornerType: .normal, backgroundColor: UIColor.black, labelColor: UIColor.white)
        switch plot.identifier {
        case "black":
            suffix = " km/h"
        case "green":
            suffix = "%"
            style = LabelInfo.Style(cornerType: .rounded(radius: 4), backgroundColor: UIColor.green, labelColor: UIColor.white)
        default:
            break
        }

        let value = self.value(forPlot: plot, atIndex: pointIndex)
        return LabelInfo(text: "\(value)\(suffix)",
                            value: value,
                            style: style,
                            point: point.location)
    }

    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        // Data for the graphs with a single plot
        case "black":
            return simpleLinePlotData[pointIndex]
        case "green":
            return orangeLinePlotData[pointIndex]
        default:
            return 0
        }
    }

    func label(atIndex pointIndex: Int) -> String {
        return "hi"
    }

    func numberOfPoints() -> Int {
        return 60
    }

}

