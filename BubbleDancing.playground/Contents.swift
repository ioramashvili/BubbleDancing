import UIKit
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.backgroundColor = .black


class BubbleDancingView: UIView {
    
    lazy var bubbles: [UIView] = {
        let views = [UIView(), UIView(), UIView()]
        
        views.forEach {
            $0.backgroundColor = .white
            self.addSubview($0)
        }
        
        return views
    }()
    
    var marginTop: CGFloat {
        return (bounds.height - bubbleWidth) / 2
    }
    
    var marginLeft: CGFloat {
        return bounds.width / 7
    }
    
    var bubbleWidth: CGFloat {
        return bounds.width / 7
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func sharedInitialization() {
        bubbles.enumerated().forEach {
            let mult = CGFloat(2 * $0.offset + 1)
            $0.element.frame = CGRect(x: mult * marginLeft, y: marginTop, width: bubbleWidth, height: bubbleWidth)
            $0.element.layer.cornerRadius = $0.element.bounds.width / 2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sharedInitialization()
    }
    
    func addAnimation() {
        bubbles.enumerated().forEach {
            let positionY = $0.element.layer.presentation()?.position.y
            let beginTime = CACurrentMediaTime() + 0.2 * Double($0.offset)
            let duration: Double = 0.4
            
            let animation1 = CABasicAnimation(keyPath: "position.y")
            animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation1.duration = duration
            animation1.fromValue = positionY
            animation1.toValue = -10
            animation1.beginTime = beginTime
            animation1.repeatCount = 1
            animation1.isRemovedOnCompletion = false
            animation1.autoreverses = true
            animation1.delegate = self
            animation1.setValue($0.offset, forKey: "index")
            
            $0.element.layer.add(animation1, forKey: nil)
        }
    }
}

extension BubbleDancingView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let index = anim.value(forKey: "index") as? Int, index == bubbles.count - 1 else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) {
            self.addAnimation()
        }
    }
}


let bubbleDancing = BubbleDancingView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
bubbleDancing.center = view.center
bubbleDancing.addAnimation()


view.addSubview(bubbleDancing)
PlaygroundPage.current.liveView = view
