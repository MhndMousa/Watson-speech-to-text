
import UIKit


class CurvedView: UIView {
    
    var myBezier = UIBezierPath()
    
    override func draw(_ rect: CGRect) {
        
        let y:CGFloat = 100
        let curveTo:CGFloat = 0
        self.backgroundColor = .clear
        
//        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y))
        myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: curveTo))
        myBezier.addLine(to: CGPoint(x: rect.width, y: rect.height))
        myBezier.addLine(to: CGPoint(x: 0, y: rect.height))
        myBezier.close()
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(4.0)
        UIColor.init(red: 1, green:1 , blue: 1, alpha: 0.9).setFill()
        myBezier.fill()

    }
    
    func colorIt(c:UIColor)  {
        
        c.setFill()
        myBezier.fill()
    }
    
//     func draw(_ rect: CGRect, color: UIColor) {
//
//        let y:CGFloat = 50
//        let curveTo:CGFloat = 0
//        self.backgroundColor = .clear
//
//        let myBezier = UIBezierPath()
//        myBezier.move(to: CGPoint(x: 0, y: y))
//        myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: curveTo))
//        myBezier.addLine(to: CGPoint(x: rect.width, y: rect.height))
//        myBezier.addLine(to: CGPoint(x: 0, y: rect.height))
//        myBezier.close()
//        let context = UIGraphicsGetCurrentContext()
//        context!.setLineWidth(4.0)
//        color.setFill()
//        myBezier.fill()
//    }
}

class CurvedViewWithAlpha: UIView {
    
    var myBezier = UIBezierPath()
    
    override func draw(_ rect: CGRect) {
        
        let y:CGFloat = 100
        let curveTo:CGFloat = 0
        self.backgroundColor = .clear
        
        //        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y))
        myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: curveTo))
        myBezier.addLine(to: CGPoint(x: rect.width, y: rect.height))
        myBezier.addLine(to: CGPoint(x: 0, y: rect.height))
        myBezier.close()
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(4.0)
        UIColor.init(red: 1, green:1 , blue: 1, alpha: 0.4).setFill()
        myBezier.fill()
        
    }
    
    func colorIt(c:UIColor)  {
        
        c.setFill()
        myBezier.fill()
    }
    
    //     func draw(_ rect: CGRect, color: UIColor) {
    //
    //        let y:CGFloat = 50
    //        let curveTo:CGFloat = 0
    //        self.backgroundColor = .clear
    //
    //        let myBezier = UIBezierPath()
    //        myBezier.move(to: CGPoint(x: 0, y: y))
    //        myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: curveTo))
    //        myBezier.addLine(to: CGPoint(x: rect.width, y: rect.height))
    //        myBezier.addLine(to: CGPoint(x: 0, y: rect.height))
    //        myBezier.close()
    //        let context = UIGraphicsGetCurrentContext()
    //        context!.setLineWidth(4.0)
    //        color.setFill()
    //        myBezier.fill()
    //    }
}
