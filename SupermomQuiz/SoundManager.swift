//
//  SoundManager.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 12/10/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    static let sharedInstance = SoundManager()
    
    override init() {
        super.init()
        audioPlayer = AVAudioPlayer()
    }
    
    func playSoundForAnswer(forAnswerType ans: Bool) {
        var soundURL = NSURL()
        switch ans {
        case true:
            soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("right", ofType: "mp3", inDirectory: "audios")!)
        case false:
            soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wrong", ofType: "mp3", inDirectory: "audios")!)
        }
        if AISettings.sharedInstance.isSoundsOn {
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
                audioPlayer?.play()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func playTapSound() {
        if AISettings.sharedInstance.isSoundsOn {
            let tapSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tap", ofType: "mp3", inDirectory: "audios")!)
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: tapSoundURL)
                audioPlayer?.play()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    
    func playBackgroundMusic() {
        if AISettings.sharedInstance.isSoundsOn {
            let backgroundMusicURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("background_music", ofType: "mp3", inDirectory: "audios")!)
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch let error as NSError {
                print(error)
            }
        }
        
        
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
}

