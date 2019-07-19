//
//  JoyStick.swift
//  MobiMini
//
//  Created by Edward on 7/16/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit

class JoyStick: UIView {
    var delegate: RobotControl?
    var stick: UIView!
    
    var panGesture = UIPanGestureRecognizer()
    var absoluteCenter = CGPoint()
    var initialCenter = CGPoint()
    
    enum RobotState {
        case forward
        case backward
        case right
        case left
        case stop
    }
    
    var lastState: RobotState = .stop
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    var radius: CGFloat!
    var stickRadius: CGFloat!
    
    init(x: CGFloat, y: CGFloat, radius: CGFloat, stickRadius: CGFloat) {
        super.init(frame: CGRect(x: x, y: y, width: radius*2, height: radius*2))
        self.radius = radius
        self.stickRadius = stickRadius
        
        setupView()
        setupStick()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.gray
        self.absoluteCenter = self.center
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func setupStick() {
        stick = UIView(frame: CGRect(x: frame.midX, y: frame.midY, width: stickRadius*2, height: stickRadius*2))
        stick.center = self.center
        
        stick.layer.cornerRadius = stick.frame.size.width / 2
        stick.clipsToBounds = true
        
        stick.backgroundColor = UIColor.darkGray
        
        panGesture.addTarget(self, action: #selector(handleStickPan))
        stick.addGestureRecognizer(panGesture)
        self.addSubview(stick)
    }
    
    @objc
    func handleStickPan(recognizer: UIPanGestureRecognizer) {
        guard panGesture.view != nil else { return }
        let translation = panGesture.translation(in: stick.superview)
        if panGesture.state == .began {
            initialCenter = stick.center
        }
        if panGesture.state != .cancelled {
            var newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            
            let angle = abs(atan(-(newCenter.y-absoluteCenter.y)/(newCenter.x-absoluteCenter.x)))
            
            newCenter.x = min(newCenter.x, radius*cos(angle)+absoluteCenter.x)
            newCenter.x = max(newCenter.x, absoluteCenter.x-radius*cos(angle))

            newCenter.y = max(newCenter.y, absoluteCenter.y-radius*sin(angle))
            newCenter.y = min(newCenter.y, (radius*sin(angle))+absoluteCenter.y)
            
            stick.center = newCenter
            x = (newCenter.x-absoluteCenter.x) / radius
            y = -(newCenter.y-absoluteCenter.y) / radius
            
            if abs(x) > abs(y) {
                if x > 0 && lastState != .right {
                    delegate?.right()
                    lastState = .right
                }
                else if x < 0 && lastState != .left {
                    delegate?.left()
                    lastState = .left
                }
            }
            else if abs(x) < abs(y) {
                if y > 0 && lastState != .forward {
                    delegate?.forward()
                    lastState = .forward
                }
                else if y < 0 && lastState != .backward {
                    delegate?.backward()
                    lastState = .backward
                }
            }
        }
        else {
            stick.center = initialCenter
        }
        if panGesture.state == .ended {
            stick.center = absoluteCenter
            delegate?.stop()
            lastState = .stop
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
