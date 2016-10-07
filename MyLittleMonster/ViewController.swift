//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Terrell Robinson on 9/30/16.
//  Copyright © 2016 FlyGoody. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImage: MonsterImage!
    @IBOutlet weak var foodImage: DragImage!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var restartButton: UIButton!
    

    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: Timer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: NSNotification.Name(rawValue: "onTargetDropped"), object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(_ notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.isUserInteractionEnabled = false
        
        heartImage.alpha = DIM_ALPHA
        heartImage.isUserInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        
        // Stop the initial timer
        if timer != nil {
            timer.invalidate()
        }
        
        // Starts/Restarts Timer
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }

    func changeGameState() {
        
        if !monsterHappy {
            
            penalties += 1
            sfxSkull.play()
            
            if penalties == 1 {
                
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
                
            } else if penalties == 2 {
                
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
                
            } else if penalties >= 3 {
                
                penalty3Img.alpha = OPAQUE
                
            } else {
                
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
                
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
                
            }
        }

        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.isUserInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.isUserInteractionEnabled = true
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.isUserInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.isUserInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
        
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImage.playDeathAnimation()
        sfxDeath.play()
        restartButton.isHidden = false
    }
    
    func gameRestart() {
        
        monsterImage.playIdleAnimation()
        
        penalties = 0
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        restartButton.isHidden = true
        
        startTimer()
        
    }
    
    
    @IBAction func restartButtonTapped(_ sender: AnyObject) {
        gameRestart()
    }


}

