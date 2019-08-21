//
//  PathView.swift
//  FeiyangYang-Lab3
//
//  Created by 杨飞扬 on 10/2/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit

class PathView: UIView {
    var thePath: BoardPath? {
        didSet {
            setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing
    override func draw(_ rect: CGRect) {

        let length = thePath!.points.count
        let thickness = (thePath?.thickness)!
        let color: UIColor = (thePath?.color)!
        let alpha = (thePath?.alpha)!
        
        let path = createQuadPath(points: thePath!.points)
        path.lineWidth = thickness
        color.setStroke()
        path.stroke(with: .normal, alpha: alpha)
        
        let dot1 = createDot(point: thePath!.points[0], radius: thickness/2)
        let dot2 = createDot(point: thePath!.points[length-1], radius: thickness/2)
        color.setFill()
        dot1.fill(with: .normal, alpha: alpha)
        dot2.fill(with: .normal, alpha: alpha)
    }
    // Calculate the mid of two points
    private func midpoint(fir: CGPoint, sec: CGPoint) -> CGPoint {
        let midX = (fir.x + sec.x)/2
        let midY = (fir.y + sec.y)/2
        return CGPoint(x: midX, y: midY)
    }
    
    // The code is given by professor in lab3.pdf
    func createQuadPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        if points.count < 2 { return path }
        let firstPoint = points[0]
        let secondPoint = points[1]
        let firstMidpoint = midpoint(fir: firstPoint, sec: secondPoint)
        path.move(to: firstPoint)
        path.addLine(to: firstMidpoint)
        for index in 1 ..< points.count-1 {
            let currentPoint = points[index]
            let nextPoint = points[index + 1]
            let midPoint = midpoint(fir: currentPoint, sec: nextPoint)
            path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
        }
        guard let lastLocation = points.last else { return path }
        path.addLine(to: lastLocation)
        return path
    }
    // if click, a dot should appear
    func createDot(point: CGPoint, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(withCenter: point, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        return path
    }
}
