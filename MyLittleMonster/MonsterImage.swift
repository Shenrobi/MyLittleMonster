//
//  MonsterImage.swift
//  MyLittleMonster
//
//  Created by Terrell Robinson on 9/30/16.
//  Copyright © 2016 FlyGoody. All rights reserved.
//

import Foundation
import UIKit

class MonsterImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        
        self.image = UIImage(named: "idle1.png")
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        for var x in 1...4 {
            let img = UIImage(named: "idle\(x).png")
            imageArray.append(img!)
            x += 1
        }
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        
        //Set default image to last animation
        self.image = UIImage(named: "dead5.png")
        //Resets animation images to nil
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        for var x in 1...5 {
            let img = UIImage(named: "dead\(x).png")
            imageArray.append(img!)
            x += 1
        }
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
    
    
}
