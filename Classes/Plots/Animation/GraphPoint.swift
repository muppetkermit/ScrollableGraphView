import UIKit

public class GraphPoint {
    
    open var location = CGPoint(x: 0, y: 0)
    open var currentlyAnimatingToPosition = false
    
    open var x: CGFloat {
        get {
            return location.x
        }
        set {
            location.x = newValue
        }
    }
    
    open var y: CGFloat {
        get {
            return location.y
        }
        set {
            location.y = newValue
        }
    }
    
    public init(position: CGPoint = CGPoint.zero) {
        x = position.x
        y = position.y
    }
}
