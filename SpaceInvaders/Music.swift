//
//  Music.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-23.
//

import Foundation
import AVFoundation
import SpriteKit

class Music : SKScene{
    static var music = Music()
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    func playBackgroundMusic(filename: String)
    {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        
        if (url == nil)
        {
            print("Could not find file: \(filename)")
            return
        }
        
        do
        {
            try backgroundMusicPlayer = AVAudioPlayer(contentsOf: url!)
        }
        catch
        {
            print("Could not create audio player")
        }

        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
    func stopBackgroundMusic()
    {
        if backgroundMusicPlayer != nil
        {
            backgroundMusicPlayer.stop()
        }
    }
}
