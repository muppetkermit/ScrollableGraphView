
import UIKit

internal class ScrollableGraphViewDrawingLayer : CAShapeLayer {
    
    var offset: CGFloat = 0 {
        didSet {
            offsetDidChange()
        }
    }

    var linePositionType: LinePositioningType = .relative

    var absoluteOffset: CGFloat = 0 {
        didSet {
            self.frame.origin.x = absoluteOffset
        }
    }
    
    var viewportWidth: CGFloat = 0
    var viewportHeight: CGFloat = 0
    var zeroYPosition: CGFloat = 0
    
    weak var owner: GraphPlot? {
        didSet {
//            debugRect()
        }
    }
    
    var active = true
    
    init(viewportWidth: CGFloat, viewportHeight: CGFloat, offset: CGFloat = 0) {
        super.init()
        
        self.viewportWidth = viewportWidth
        self.viewportHeight = viewportHeight
        
        self.frame = CGRect(origin: CGPoint(x: offset, y: 0), size: CGSize(width: self.viewportWidth, height: self.viewportHeight))
        setup()
    }

    var label: UILabel!
    private func debugRect() {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: self.frame, cornerRadius: 15).cgPath
        layer.fillColor = UIColor.red.withAlphaComponent(0.2).cgColor
        label = UILabel()
        label.text = "\(self.owner?.identifier ?? "NO")"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.frame = CGRect(x: self.frame.width, y: 10 + CGFloat(arc4random_uniform(UInt32(100))), width: 150, height: 20)
        self.addSublayer(layer)
        self.addSublayer(label.layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // Get rid of any animations.
        self.actions = ["position" : NSNull(), "bounds" : NSNull()]
    }
    
    private func offsetDidChange() {
        self.frame.origin.x = offset
        self.bounds.origin.x = offset
    }
    
    func updatePath() {
        fatalError("updatePath needs to be implemented by the subclass")
    }
}

@objc public enum LinePositioningType : Int {
    case relative
    case absolute
}
