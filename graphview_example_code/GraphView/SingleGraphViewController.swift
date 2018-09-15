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
    // Data for graphs with a single plot
    lazy var simpleLinePlotData: [Double] = self.generateRandomData(10000, max: 80, shouldIncludeOutliers: false)
    lazy var orangeLinePlotData: [Double] =  self.generateRandomData(10000, max: 60, shouldIncludeOutliers: true)
    var imageView1: UIImageView?
    var imageView2: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView = createSimpleGraph(self.view.frame)
        graphView.bottomMargin = 0
        graphView.topMargin = 0
        graphView.rangeMax = 100
        graphView.rangeMin = 0
        self.view.addSubview(graphView)
        setupConstraints()
    }
    
    fileprivate func createSimpleGraph(_ frame: CGRect) -> ScrollableGraphView {

        // Compose the graph view by creating a graph, then adding any plots
        // and reference lines before adding the graph to the view hierarchy.
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#1A1C1D")
        graphView.dataPointSpacing = 10
        let linePlot = LinePlot(identifier: "red")
        let linePlot2 = LinePlot(identifier: "blue")// Identifier should be unique for each plot.
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor.red
        linePlot2.lineWidth = 1
        linePlot2.lineColor = UIColor.colorFromHex(hexString: "#4DA3E2")
        // Setup the second plot.
//        let orangeLinePlot = LinePlot(identifier: "green")
//
//        orangeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#71D637")
//        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
//
//        // squares on the line
//        let orangeSquarePlot = DotPlot(identifier: "multiOrangeSquare")
//        orangeSquarePlot.dataPointType = ScrollableGraphViewDataPointType.square
//        orangeSquarePlot.dataPointSize = 5
//        orangeSquarePlot.dataPointFillColor = UIColor.colorFromHex(hexString: "#71D637")
//
//        orangeSquarePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

//        let referenceLines = ReferenceLines()
        let axisLine1 = AxisLine()
        axisLine1.axisLineIndex = 0
        axisLine1.axisLineColor = UIColor.white
        axisLine1.axisLabelPosition = .middleLeft
        axisLine1.axisLinePosition = .absolute
        axisLine1.axisLineAbsoluteRatio = 0.5
        
        graphView.leftmostPointPadding = graphView.frame.width / 2
        graphView.rightmostPointPadding = graphView.frame.width / 2
        graphView.bounces = false
        graphView.shouldAnimateOnStartup = false
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: linePlot2)
        graphView.addAxisLine(axisLine: axisLine1)
//        graphView.addReferenceLines(referenceLines: referenceLines)

        return graphView
    }

    private func setupConstraints() {

        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()

        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 100)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -500)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)

        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)

        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)

        //graphConstraints.append(heightConstraint)

        self.view.addConstraints(graphConstraints)
    }

    // Data Generation
    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max - 10)

            data.append(randomNumber + 10)
        }
        return data
    }
}

extension SingleGraphViewController: ScrollableGraphViewDataSource {

    func label(forPlot plot: Plot, atIndex pointIndex: Int) -> LabelInfo? {
        guard let point = plot.graphPoint(forIndex: pointIndex) else {
            return nil
        }
        let originY = 100 + point.location.y - 10
        let originX = self.view.frame.width / 2 - 10
        var suffix = ""
        var position = ScrollableGraphViewAxisLabelPosition.middleLeft
        var style = LabelInfo.Style(cornerType: .normal, backgroundColor: UIColor.red.withAlphaComponent(0.8), labelColor: UIColor.white, size: CGSize(width: 48, height: 20), font: UIFont.systemFont(ofSize: 12))
        switch plot.identifier {
        case "red":
            suffix = ""
            if imageView1 == nil {
                imageView1 = UIImageView(frame: CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: 20, height: 20)))
                imageView1!.image = #imageLiteral(resourceName: "point_red")
                self.view.addSubview(imageView1!)
                self.view.bringSubview(toFront: imageView1!)
            } else {
                imageView1?.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: 20, height: 20))
            }
        case "blue":
            suffix = ""
            position = .middleRight
            style = LabelInfo.Style(cornerType: .rounded(radius: 4), backgroundColor: UIColor.colorFromHex(hexString: "#277AC1").withAlphaComponent(0.8), labelColor: UIColor.white, size: CGSize(width: 48, height: 20), font: UIFont.systemFont(ofSize: 12))
            if imageView2 == nil {
                imageView2 = UIImageView(frame: CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: 20, height: 20)))
                imageView2!.image = #imageLiteral(resourceName: "point_blue")
                self.view.addSubview(imageView2!)
                self.view.bringSubview(toFront: imageView2!)
            } else {
                imageView2?.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: 20, height: 20))
            }
        default:
            break
        }

        let value = self.value(forPlot: plot, atIndex: pointIndex)
        return LabelInfo(text: " \(value)\(suffix)",
                            value: value,
                            style: style,
                            point: point.location,
                            position: position)
    }

    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        // Data for the graphs with a single plot
        case "red":
            return simpleLinePlotData[pointIndex]
        case "blue":
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

